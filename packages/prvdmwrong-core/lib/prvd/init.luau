--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local RunService = game:GetService("RunService")

local Lifecycles = require("prvdmwrong-core/lifecycles")
local Modding = require("prvdmwrong-core/modding")
local Reflection = require("prvdmwrong-core/modding/reflection")
local Types = require("prvdmwrong-core/types")
local log = require("prvdmwrong-core/utils/log")
local providers = require("prvdmwrong-core/prvd/providers")
local threads = require("prvdmwrong-core/utils/threads")

local WEAK_KEYS_METATABLE = { __mode = "k" }
local DEFAULT_OPTIONS: Types.Options = {
  logLevel = "none",
  profiling = RunService:IsStudio(),
}

local StartupStatus = table.freeze {
  Pending = "StartupStatus.Pending" :: "StartupStatus.Pending",
  Starting = "StartupStatus.Starting" :: "StartupStatus.Starting",
  Started = "StartupStatus.Started" :: "StartupStatus.Started",
}

-- If we held strong references to threads here, then if a thread was killed
-- before Prvd 'M Wrong is ignited, it would be held strongly in this table forever
local awaitingThreads: { [thread]: true } = setmetatable({} :: any, WEAK_KEYS_METATABLE)
local awaitingCallbacks: { () -> () } = {}

local status: Types.StartupStatus = StartupStatus.Pending
local startupOptions: Types.Options? = nil

local prvd = {}
prvd.StartupStatus = StartupStatus

local function reconcileOptions(options: { [any]: any }): Types.Options
  local reconciled = table.clone(DEFAULT_OPTIONS)
  for key, value in pairs(reconciled) do
    local givenValue = options[key]
    if givenValue and typeof(givenValue) == typeof(value) then
      reconciled[key] = givenValue
    end
  end
  table.freeze(reconciled)
  return reconciled
end

-- This returns a map because table.sort is unstable.
local function topoSort(objects: { string }): { [string]: number }
  local currentSize = 0
  local sorted: { [string]: number } = {}
  local visited: { [string]: true } = {}

  local function visitor(node: string)
    if visited[node] then
      return
    end
    visited[node] = true

    local object = Reflection.idToObject[node]
    if object == nil then
      return
    end

    local dependencies = Reflection.getMetadata(object, "prvdmwrong:dependencies") :: { string }
    for _, dependency in pairs(dependencies or {}) do
      visitor(dependency)
    end

    currentSize += 1
    sorted[node] = currentSize
  end

  for _, node in ipairs(objects) do
    visitor(node)
  end

  return sorted
end

--[=[
  Starts Prvd 'M Wrong. log.expected to be called once in an environment, e.g. once on
  the server and once on the client.

  All necessary providers should be preloaded before calling this as newly
  created providers will not run its lifecycles methods.
]=]
function prvd.start(options: {
  logLevel: "none" | "verbose" | nil,
  profiling: boolean?,
}?)
  log.expect(status == StartupStatus.Pending, "alreadyStarted")
  status = StartupStatus.Starting

  local reconciledOptions = reconcileOptions(options or {})
  startupOptions = reconciledOptions

  local isVerbose = reconciledOptions.logLevel == "verbose"
  local function verbose(...: unknown)
    if isVerbose then
      print("[Prvd 'M Wrong (verbose)]:", ...)
    end
  end

  local isProfiling = reconciledOptions.profiling == true
  local function profileCallback<Args...>(callback: (Args...) -> (), label: string)
    if isProfiling then
      return callback
    end
    return function(...: Args...)
      -- profilebegin ends when the thread dies
      debug.profilebegin(label)
      debug.setmemorycategory(label)
      callback(...)
      debug.resetmemorycategory()
    end
  end

  -- stylua: ignore
  -- see https://github.com/JohnnyMorganz/StyLua/issues/881
  local dependencies: {
    {
      instance: Types.Provider<unknown>,
      loadOrder: number,
      identifier: string,
    }
  } = {}

  for provider in pairs(Modding.providers) do
    if not Reflection.getMetadata(provider, "prvdmwrong:provider") then
      continue
    end

    table.insert(dependencies, {
      instance = provider,
      loadOrder = provider.loadOrder or 1,
      identifier = Reflection.getIdentifier(provider),
    })

    local encountered = {}
    local usedDependencies = {}
    local function resolveUsedDependencies(target: unknown, key: unknown, parent: { [unknown]: unknown })
      if encountered[target] then
        return
      end
      encountered[target] = true
      if typeof(target) ~= "table" then
        return
      end
      if Modding.providers[target :: any] then
        parent[key] = (target :: any)[providers.providerKey] or target
        table.insert(usedDependencies, Reflection.getIdentifier(target))
        return
      end
      for key, value in pairs(target :: Types.Object) do
        resolveUsedDependencies(value, key, target :: Types.Object)
      end
    end

    resolveUsedDependencies(provider, nil, provider)
    Reflection.defineMetadata(provider, "prvdmwrong:dependencies", usedDependencies)
  end

  local identifiers = {}
  for index, dependency in ipairs(dependencies) do
    identifiers[index] = dependency.identifier
  end

  local sortedDependencies = topoSort(identifiers)
  table.sort(dependencies, function(a, b)
    if a.loadOrder ~= b.loadOrder then
      return a.loadOrder < b.loadOrder
    end
    local aIndex = sortedDependencies[a.identifier]
    local bIndex = sortedDependencies[b.identifier]
    return aIndex < bIndex
  end)

  local onInit: Types.Lifecycle<Types.OnInit> = Lifecycles.Lifecycle("onInit", function(self)
    for _, provider in ipairs(self.listeners) do
      local identifier = Reflection.getIdentifier(provider, ":onInit")
      if reconciledOptions.profiling then
        debug.setmemorycategory(identifier)
      end

      verbose("running lifecycle", identifier)

      local ok, result: any = xpcall(provider.onInit, log.parseError, provider)
      if not ok then
        local error: Types.Error = result
        log.throw("onInitError", error.trace, identifier, error.message)
      end
    end
  end)

  local onStart: Types.Lifecycle<Types.OnStart> = Lifecycles.Lifecycle("onStart", function(self)
    for _, provider in ipairs(self.listeners) do
      local identifier = Reflection.getIdentifier(provider, ":onStart")
      verbose("running lifecycle", identifier)
      threads.spawn(profileCallback(provider.onStart, identifier), provider)
    end
  end)

  for _, provider in ipairs(dependencies) do
    Lifecycles.implementAll(provider.instance)
  end

  onInit:fire()
  debug.resetmemorycategory()
  onStart:fire()

  for _, callback in pairs(awaitingCallbacks) do
    threads.spawn(callback)
  end

  status = StartupStatus.Started
end

--[=[
  Queues a callback to be called just before ignition finishes. If Prvd 'M Wrong
  has already started, the callback will be spawned immediately.
]=]
function prvd.onStart(callback: () -> ())
  if status ~= StartupStatus.Pending then
    threads.spawn(callback)
    return
  end
  log.expect(typeof(callback) == "function", "invalidOnIgnitionCallback")
  table.insert(awaitingCallbacks, callback)
end

--[=[
  Yields the calling thread just before ignition finishes. If Prvd 'M Wrong has
  already started, the thread will continue.
]=]
function prvd.awaitStart()
  if status ~= StartupStatus.Pending then
    return
  end
  awaitingThreads[coroutine.running()] = true
  coroutine.yield()
end
prvd.onStart(function()
  for thread in pairs(awaitingThreads) do
    task.spawn(thread)
  end
end)

--[=[
  Returns the start configuration options. Options are reconciled with
  default values.
]=]
function prvd.getStartupOptions(): Types.Options
  return reconcileOptions(startupOptions or {})
end

--[=[
  Returns the current startup status of Prvd 'M Wrong.
]=]
function prvd.getStartupStatus(): Types.StartupStatus
  return status
end

function prvd.use<T>(provider: Types.Provider<T>): T
  log.warn("useWasDeprecated")
  return provider
end

table.freeze(prvd)
return prvd
