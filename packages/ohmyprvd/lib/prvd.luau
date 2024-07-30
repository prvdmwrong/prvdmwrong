--!strict
--!nolint LocalShadow

--[[

  Copyright 2024 Team Fireworks

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the “Software”), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so,subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

]]

local RunService = game:GetService("RunService")

local package = script.Parent
local log = require(package.utils.log)
local mods = require(package.mods)
local promise = require(package.utils.promise)
local reflect = require(package.reflect)
local threads = require(package.utils.threads)
local types = require(package.types)
local expect = log.expect
local info = log.info
local parseError = log.parseError
local throw = log.throw

export type IgnitionStatus = types.IgnitionStatus
export type Options = types.Options
export type Provider<T> = types.Provider<T>
type Error = types.Error

local WEAK_KEYS_METATABLE = { __mode = "k" }

local DEFAULT_OPTIONS: Options = {
  logLevel = "none",
  profiling = RunService:IsStudio(),
}

local EXPECTED_METHOD_TYPES = {
  loadOrder = "number",
  onInit = "function",
  onStart = "function",
}

local IgnitionStatus = table.freeze {
  Pending = "IgnitionStatus.Pending" :: "IgnitionStatus.Pending",
  Igniting = "IgnitionStatus.Igniting" :: "IgnitionStatus.Igniting",
  Ignited = "IgnitionStatus.Ignited" :: "IgnitionStatus.Ignited",
}

-- If we held strong references to threads here, then if a thread was killed
-- before Oh My Prvd is ignited, it would be held strongly in this table forever
local awaitingThreads: { [thread]: true } = setmetatable({} :: any, WEAK_KEYS_METATABLE)
local awaitingCallbacks: { () -> () } = {}
local status: IgnitionStatus = IgnitionStatus.Pending

local providers: { [string]: Provider<any> } = {}
local ignitionOptions: Options? = nil

local prvd = {}
prvd.IgnitionStatus = IgnitionStatus

local function topologicalSort(objects: { string }): { [string]: number }
  -- TODO: account for cyclic requires
  local currentSize = 0
  local sorted: { [string]: number } = {}
  local visited: { [string]: true } = {}

  local function visitor(node: string)
    if visited[node] then
      return
    end
    visited[node] = true

    local object = reflect.idToObject[node]
    if object == nil then
      return
    end

    local dependencies = reflect.getMetadata(object, "ohmyprvd:dependencies") :: { string }
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

local function getIdentifier(object: unknown, suffix: string?): string
  local suffix = suffix or ""
  local identifier = reflect.getMetadata(object, "identifier")
  if typeof(identifier) == "string" then
    return identifier .. suffix
  end
  return "unknownProvider" .. suffix
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
  Constructs and returns a new provider within Oh My Prvd. Providers must be
  created before calling `Prvd.ignite()`.
]]
function prvd.Provider<T>(name: string, provider: T): Provider<T>
  expect(status == IgnitionStatus.Pending, "registerAfterIgnition")
  expect(typeof(name) == "string", "cannotRegister", nil, "`name` must be a string")
  expect(name:len() > 0, "cannotRegister", nil, "`name` cannot be empty")
  expect(typeof(provider) == "table", "cannotRegister", nil, "provider must be a table")
  expect(not table.isfrozen(provider :: any), "cannotRegister", nil, "provider cannot be frozen")
  expect(providers[name] == nil, "cannotRegister", nil, `already registered "{name}"`)

  local provider = table.clone(provider :: Provider<T>) :: Provider<T>
  for method, expectedType in pairs(EXPECTED_METHOD_TYPES) do
    if rawget(provider, method) == nil then
      continue
    end
    local realType = typeof(rawget(provider, method))
    expect(expectedType == realType, "cannotRegister", `\`{name}.{method}\` should be a {expectedType}`)
  end

  reflect.defineMetadata(provider, "ohmyprvd:provider", true)
  reflect.defineMetadata(provider, "identifier", name)
  reflect.defineMetadata(provider, "ohmyprvd:loadOrder", provider.loadOrder)
  providers[name] = provider
  mods.doProviderConstructed(provider)
  return provider
end

--[[
  Uses a provider within Oh My Prvd. During ignition, Oh My Prvd will inject
  the dependencies your provider uses.
]]
function prvd.use<T>(provider: Provider<T>): T
  expect(status == IgnitionStatus.Pending, "useAfterIgnition")
  expect(providers[getIdentifier(provider)] ~= nil, "cannotUseNonProvider")
  local identifier = getIdentifier(provider)
  mods.doProviderUsed(provider)
  return setmetatable(
    {
      __prvdRequired__ = provider,
    } :: any,
    {
      __metatable = "This metatable is locked.",
      __index = function(_: unknown, key: unknown): never
        return throw("usedBeforeIgnition", nil, identifier)
      end,
    }
  )
end

--[[
  Ignites Oh My Prvd. Expected to be called once in an environment, e.g. once on
  the server and once on the client.

  All necessary providers should be preloaded before calling this as newly
  created providers will not run its lifecycle events.
]]
function prvd.ignite(options: {
  logLevel: "none" | "verbose" | nil,
  profiling: boolean?,
}?)
  expect(status == IgnitionStatus.Pending, "alreadyIgnited")
  status = IgnitionStatus.Igniting

  local options = reconcileOptions(options or {})
  ignitionOptions = options

  local isVerbose = options.logLevel == "verbose"
  local function verbose(id: string, ...: unknown)
    if isVerbose then
      info(id, ...)
    end
  end

  local isProfiling = options.profiling == true
  local function profileCallback<Args...>(callback: (Args...) -> (), label: string)
    if isProfiling then
      return callback
    end
    return function(...: Args...)
      -- profilebegin ends when the thread dies
      debug.profilebegin(label)
      debug.setmemorycategory(label)
      callback()
      debug.resetmemorycategory()
    end
  end

  local dependencies: { { instance: Provider<any>, loadOrder: number, identifier: string } } = {}
  for _, provider in pairs(providers) do
    table.insert(dependencies, {
      instance = provider,
      loadOrder = rawget(provider, "loadOrder") or 1,
      identifier = getIdentifier(provider),
    })

    if not reflect.getMetadata(provider, "ohmyprvd:provider") then
      continue
    end

    local encountered = {}
    local dependencies = {}
    local function resolveDependencies(target: unknown, key: unknown, parent: { [unknown]: unknown })
      if encountered[target] then
        return
      end
      encountered[target] = true
      if typeof(target) ~= "table" then
        return
      end
      local target = target :: { [any]: any }
      local required = target.__prvdRequired__
      if required ~= nil then
        -- TODO: check if this is a good idea lmfao
        parent[key] = required
        table.insert(dependencies, getIdentifier(required))
      end
      for key, value in pairs(target) do
        resolveDependencies(value, key, target)
      end
    end

    resolveDependencies(provider, nil, provider)
    reflect.defineMetadata(provider, "ohmyprvd:dependencies", dependencies)
  end

  local identifiers = {}
  for index, dependency in ipairs(dependencies) do
    identifiers[index] = getIdentifier(dependency.instance)
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

  local init: { Provider<any> } = {}
  local start: { Provider<any> } = {}

  for _, provider in ipairs(dependencies) do
    local provider = provider.instance
    if typeof(provider.onInit) == "function" then
      table.insert(init, provider)
    end
    if typeof(provider.onStart) == "function" then
      table.insert(start, provider)
    end
    mods.implementAllMethods(provider)
  end

  -- Initializing
  for _, provider in ipairs(init) do
    local identifier = getIdentifier(provider, ".onInit")
    if options.profiling then
      debug.setmemorycategory(identifier)
    end
    verbose("lifecycleEvent", identifier)
    local ok, result = xpcall(provider.init, parseError, provider)
    if not ok then
      local error: Error = result
      throw("initError", error.trace, getIdentifier(provider), error.message)
    elseif promise.is(result) then
      local promise: promise.Promise = result
      local status, value = promise:awaitStatus()
      if status == "Rejected" then
        throw("initError", nil, getIdentifier(provider), value)
      end
    end
  end

  debug.resetmemorycategory()

  -- Starting
  for _, provider in ipairs(start) do
    local identifier = getIdentifier(provider, ".onStart")
    verbose("lifecycleEvent", identifier)
    threads.spawn(profileCallback(provider.start, identifier), provider)
  end

  for thread in pairs(awaitingThreads) do
    task.spawn(thread)
  end
  for _, callback in pairs(awaitingCallbacks) do
    threads.spawn(callback)
  end

  status = IgnitionStatus.Ignited
end

--[[
  Yields the calling thread just before ignition finishes. If Oh My Prvd has
  already started, the thread will continue.
]]
function prvd.awaitIgnition()
  if status ~= IgnitionStatus.Pending then
    return
  end
  awaitingThreads[coroutine.running()] = true
  coroutine.yield()
end

--[[
  Queues a callback to be called just before ignition finishes. If Oh My Prvd
  has already started, the callback will be spawned immediately.
]]
function prvd.onIgnition(callback: () -> ())
  if status ~= IgnitionStatus.Pending then
    threads.spawn(callback)
    return
  end
  expect(typeof(callback) == "function", "invalidOnIgnitionCallback")
  table.insert(awaitingCallbacks, callback)
end

--[[
  Returns the ignition configuration options. Options are reconciled with
  default values.
]]
function prvd.getIgnitionOptions(): Options
  return reconcileOptions(ignitionOptions or {})
end

table.freeze(prvd)
return prvd
