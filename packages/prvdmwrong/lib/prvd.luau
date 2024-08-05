--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local RunService = game:GetService("RunService")

local Lifecycles = require("@core/lifecycles")
local Log = require("@core/log")
local Modding = require("@core/modding")
local Reflection = require("@core/reflection")
local Types = require("@core/types")
local Utils = require("@core/utils")
local expect = Log.expect
local parseError = Log.parseError
local throw = Log.throw

type Lifecycle<Interface = { [any]: any }> = Types.Lifecycle<Interface>
type OnInit = Types.OnInit
type OnStart = Types.OnStart
type Options = Types.Options
type Provider<T> = Types.Provider<T>
type StartupStatus = Types.StartupStatus

local PROVIDER_KEY = newproxy(true) :: { __PROVIDER_KEY__: never? }
getmetatable(PROVIDER_KEY :: any).__tostring = function()
  return "prvd.PROVIDER_KEY"
end

local WEAK_KEYS_METATABLE = { __mode = "k" }

local DEFAULT_OPTIONS: Options = {
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
local status: StartupStatus = StartupStatus.Pending

local providers: { [Provider<unknown>]: string } = {}
local startupOptions: Options? = nil

local Prvd = {}
Prvd.StartupStatus = StartupStatus

local function topologicalSort(objects: { string }): { [string]: number }
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

local function reconcileOptions(options: { [any]: any }): Options
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

--[[
  Constructs and returns a new provider within Prvd 'M Wrong. Providers must be
  created before calling `Prvd.start()`.
]]
function Prvd.new<T>(provider: T): Provider<T>
  expect(status == StartupStatus.Pending, "registerAfterStarted")
  expect(typeof(provider) == "table", "cannotRegister", nil, "provider must be a table")
  expect(not table.isfrozen(provider :: any), "cannotRegister", nil, "provider cannot be frozen")

  local newProvider = provider :: Provider<T>
  expect(
    newProvider.loadOrder == nil or tonumber(newProvider.loadOrder),
    "cannotRegister",
    "`loadOrder` should be a number"
  )

  do
    -- This has to be in a do ... end block or else we get ambiguous syntax
    (newProvider :: any)[PROVIDER_KEY] = newProvider
  end

  local source = debug.info(3, "s")
  Reflection.defineMetadata(provider, "identifier", source)
  Reflection.defineMetadata(provider, "prvdmwrong:provider", true)
  Reflection.defineMetadata(provider, "prvdmwrong:loadOrder", newProvider.loadOrder)

  providers[newProvider] = source
  Modding.doProviderConstructed(newProvider)
  return newProvider
end

--[[
  Returns a decorator for providers. Intended to be used by TypeScript classes,
  where `prvd(provider)` may be unideal as a reserved keyword and subpar syntax.
]]
function Prvd.TSProvider(options: { loadOrder: number? }?)
  local reconciledOptions: { loadOrder: number? } = options or {}
  return function<T>(provider: T)
    expect(typeof(provider) == "table", "cannotRegister", nil, "provider must be a table")
    expect(not table.isfrozen(provider :: any), "cannotRegister", nil, "provider cannot be frozen")

    expect(
      typeof((provider :: any).new) == "function",
      "cannotRegister",
      nil,
      "must use TypeScript decorator on a class"
    )
    expect(
      typeof((provider :: any).__tostring) == "function",
      "cannotRegister",
      nil,
      "must use TypeScript decorator on a class"
    )

    local newProvider = (provider :: any).new()
    local name = newProvider:__tostring()

    expect(typeof(name) == "string", "cannotRegister", nil, `expected provider class __tostring to return a string`)
    expect(typeof(name) == "string", "cannotRegister", nil, "`name` must be a string")
    expect(name:len() > 0, "cannotRegister", nil, "`name` cannot be empty")

    do
      -- This has to be in a do ... end block or else we get ambiguous syntax
      (provider :: any)[PROVIDER_KEY] = newProvider
    end

    Reflection.defineMetadata(newProvider, "identifier", name)
    Reflection.defineMetadata(newProvider, "prvdmwrong:provider", true)
    Reflection.defineMetadata(newProvider, "prvdmwrong:loadOrder", reconciledOptions.loadOrder)

    providers[name] = newProvider
    Modding.doProviderConstructed(newProvider)
  end
end

--[[
  Uses a provider within Prvd 'M Wrong. During startup, Prvd 'M Wrong will inject
  the dependencies your provider uses.
]]
function Prvd.use<T>(provider: Provider<T>): T
  expect(status == StartupStatus.Pending, "useAfterStarted")
  local identifier = expect(providers[provider], "cannotUseNonProvider")
  Modding.doProviderUsed(provider)
  return setmetatable(
    {
      __prvdRequired__ = provider,
    } :: any,
    {
      __metatable = "This metatable is locked.",
      __index = function(_: unknown): never
        return throw("usedBeforeStartup", nil, identifier)
      end,
    }
  )
end

--[[
  Starts Prvd 'M Wrong. Expected to be called once in an environment, e.g. once on
  the server and once on the client.

  All necessary providers should be preloaded before calling this as newly
  created providers will not run its lifecycle methods.
]]
function Prvd.start(options: {
  logLevel: "none" | "verbose" | nil,
  profiling: boolean?,
}?)
  expect(status == StartupStatus.Pending, "alreadyStarted")
  status = StartupStatus.Starting

  local reconciledOptions = reconcileOptions(options or {})
  startupOptions = reconciledOptions

  local isVerbose = reconciledOptions.logLevel == "verbose"
  local function verbose(...: unknown)
    if isVerbose then
      print("[OMP(verbose)]:", ...)
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
      instance: Provider<unknown>,
      loadOrder: number,
      identifier: string,
    }
  } = {}

  for provider, identifier in pairs(providers) do
    table.insert(dependencies, {
      instance = provider,
      loadOrder = provider.loadOrder or 1,
      identifier = identifier,
    })
    if not Reflection.getMetadata(provider, "prvdmwrong:provider") then
      continue
    end
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
      if not table.isfrozen(target :: Types.Object) then
        local required = (target :: Types.Object).__prvdRequired__
        if required ~= nil then
          -- We've found a dependency. Add it to this provider dependencies,
          -- then return as to not iterate further.
          parent[key] = (required :: any)[PROVIDER_KEY] or required
          table.insert(usedDependencies, Reflection.getIdentifier(required))
          return
        end
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
  local sortedDependencies = topologicalSort(identifiers)
  table.sort(dependencies, function(a, b)
    if a.loadOrder ~= b.loadOrder then
      return a.loadOrder < b.loadOrder
    end
    local aIndex = sortedDependencies[a.identifier]
    local bIndex = sortedDependencies[b.identifier]
    return aIndex < bIndex
  end)

  local onInit: Lifecycle<OnInit> = Lifecycles.Lifecycle("onInit", function(self)
    for _, provider in ipairs(self.listeners) do
      local identifier = Reflection.getIdentifier(provider, ":onInit")
      if reconciledOptions.profiling then
        debug.setmemorycategory(identifier)
      end

      verbose("running lifecycle method", identifier)

      local ok, result: any = xpcall(provider.onInit, parseError, provider)
      if not ok then
        local error: Types.Error = result
        throw("onInitError", error.trace, identifier, error.message)
      end
    end
  end)

  local onStart: Lifecycle<OnStart> = Lifecycles.Lifecycle("onStart", function(self)
    for _, provider in ipairs(self.listeners) do
      local identifier = Reflection.getIdentifier(provider, ":onStart")
      verbose("running lifecycle method", identifier)
      Utils.spawn(profileCallback(provider.onStart, identifier), provider)
    end
  end)

  for _, provider in ipairs(dependencies) do
    Lifecycles.registerAll(provider.instance)
  end

  onInit:fire()
  debug.resetmemorycategory()
  onStart:fire()

  for thread in pairs(awaitingThreads) do
    task.spawn(thread)
  end
  for _, callback in pairs(awaitingCallbacks) do
    Utils.spawn(callback)
  end

  status = StartupStatus.Started
end

--[[
  Yields the calling thread just before ignition finishes. If Prvd 'M Wrong has
  already started, the thread will continue.
]]
function Prvd.awaitStart()
  if status ~= StartupStatus.Pending then
    return
  end
  awaitingThreads[coroutine.running()] = true
  coroutine.yield()
end

--[[
  Queues a callback to be called just before ignition finishes. If Prvd 'M Wrong
  has already started, the callback will be spawned immediately.
]]
function Prvd.onStart(callback: () -> ())
  if status ~= StartupStatus.Pending then
    Utils.spawn(callback)
    return
  end
  expect(typeof(callback) == "function", "invalidOnIgnitionCallback")
  table.insert(awaitingCallbacks, callback)
end

--[[
  Returns the start configuration options. Options are reconciled with
  default values.
]]
function Prvd.getStartupOptions(): Options
  return reconcileOptions(startupOptions or {})
end

--[[
  Returns the current startup status of Prvd 'M Wrong.
]]
function Prvd.getStartupStatus(): StartupStatus
  return status
end

--[[
  Preload the specified parent by requiring all ModuleScripts within it. An
  optional `predicate` function can be provided to filter modules.
]]
function Prvd.preload(instances: { Instance }, predicate: ((ModuleScript) -> boolean)?)
  local exports: { unknown } = {}
  for _, module in ipairs(instances) do
    if not module:IsA("ModuleScript") then
      continue
    end
    if predicate and not predicate(module) then
      continue
    end
    local ok, result: Types.Error = xpcall(require, parseError, module)
    expect(ok, "requireError", result.trace, module:GetFullName(), result.message)
    table.insert(exports, result)
  end
  return exports
end

--[[
  Adds the given object as a dependency that Prvd 'M Wrong will instantiate
  during startup.

  @internal
]]
function Prvd.registerDependency(identifier: string, dependency: Types.Object)
  expect(typeof(identifier) == "string", "cannotRegister", nil, "`identifier` must be a string")
  expect(identifier:len() > 0, "cannotRegister", nil, "`identifier` cannot be empty")
  expect(typeof(dependency) == "table", "cannotRegister", nil, "must be a table")
  expect(not table.isfrozen(dependency :: any), "cannotRegister", nil, "cannot be frozen")
  expect(providers[dependency :: any] == nil, "cannotRegister", nil, `already registered "{identifier}"`)
  providers[dependency :: any] = identifier
  Reflection.defineMetadata(dependency, "identifier", identifier)
end

table.freeze(Prvd)
return Prvd
