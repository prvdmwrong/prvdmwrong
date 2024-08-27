--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Promise = require("lumin-compat/vendor/promise")
local Signal = require("lumin-compat/vendor/signal")
local Types = require("lumin-compat/types")
local log = require("lumin-compat/utils/log")
local prvd = require("lumin-compat/utils/prvd")

export type WorkerType = Types.WorkerType
export type Worker = Types.Worker
export type Storage = Types.Storage

local WORKER_TYPES: { [string]: RBXScriptSignal } = {
	PostSimulation = RunService.PostSimulation,
	PreSimulation = RunService.PreSimulation,
	PreAnimation = RunService.PreAnimation,
	PreRender = RunService.PreRender,
	PlayerAdded = Players.PlayerAdded,
	PlayerRemoving = Players.PlayerRemoving,
}

local alreadyWarned: { [string]: true } = {}
local signals: { [string]: Signal.Signal<...any> } = {}
local start = Promise.promisify(prvd.start)

local lumin = {}
lumin.version = "VERSION"
lumin.alignedVersion = "9.0.0-rc6"

local function warnDeprecated(replacement: string, deprecated: string, reason: string)
	if alreadyWarned[deprecated] then
		return
	end

	alreadyWarned[deprecated] = true
	log.warn("compatDeprecated", replacement, deprecated, reason)
end

--[=[
  @deprecated Use `getStartupStatus()` instead; it returns an Enum specific to
  Prvd 'M Wrong.
]=]
lumin.Started = prvd.getStartupStatus() ~= prvd.StartupStatus.Pending
prvd.onStart(function()
	lumin.Started = true
end)

--[=[
  @deprecated Use `prvd()` instead of `Controller()`; the former is less verbose
  and pragmatic
]=]
function lumin.Controller<T>(name: string, members: T & {}): prvd.Provider<T>
	warnDeprecated("`prvd()`", "`Controller()`", "the former is less verbose and pragmatic")

	local controller = {}
	controller.name = name
	controller.onInit = (members :: any).Init
	controller.onStart = (members :: any).Start
	setmetatable(controller, {
		__index = members,
	})

	prvd.internal.registerDependency(name, controller :: any)
	prvd.internal.defineMetadata(controller, "prvdmwrong:provider", true)
	prvd.internal.defineMetadata(controller, "prvdmwrong:luminProvider", true)
	return controller :: any
end

--[=[
  @deprecated Use the `Lifecycle` object or the `@prvdmwrong/lifecycles` package
  instead of creating `Worker()`s; lifecycles have furthered customizability and
  hook onto providers, with the latter implementing all workers Lumin Framework
  offers as lifecycles.
]=]
function lumin.Worker(type: WorkerType, callback: (...any) -> ()): Worker
	warnDeprecated(
		"the `Lifecycle` object or the `@prvdmwrong/lifecycles` package",
		"creating `Worker()`s",
		"lifecycles have furthered customizability and hook onto providers, with the latter implementing all workers Lumin Framework offers as lifecycles"
	)

	local signal = log.expect(WORKER_TYPES[type], "luminMissingWorker", type)
	signal:Connect(callback)

	local self = {} :: Worker
	self.Type = type
	self.IsWorker = true
	self.Callback = callback

	table.freeze(self)
	return self
end

--[=[
  @deprecated Use a dedicated signal package instead of `Signal()`; reactive
  signals are out of scope for Prvd 'M Wrong and only provided as a
  compatibility layer.
]=]
function lumin.Signal(name: string?): Signal.Signal<...any>
	warnDeprecated(
		"a dedicated signal package",
		"`Signal()`",
		"reactive signals are out of scope for Prvd 'M Wrong and only offered as a compatibility layer"
	)

	if not name then
		return Signal.new()
	end
	local namedSignal = signals[name]
	if not namedSignal then
		namedSignal = Signal.new()
		signals[name] = namedSignal
	end
	return namedSignal
end

--[=[
  @deprecated Use `start()` and `preload()` instead of `Start()`; Prvd 'M Wrong
  is not promise based.
]=]
function lumin.Start(modules: { Instance }?): Promise.TypedPromise<()>
	warnDeprecated("`start()` and `preload()`", "`Start()`", "Prvd 'M Wrong is not promise based")
	if modules then
		for _, module in modules do
			prvd.preload(module:GetChildren())
		end
	end
	return start()
end

--[=[
  @deprecated Use the provider itself instead of `Expect()`; Prvd 'M Wrong can
  figure out dependencies by specifying it directly.
]=]
function lumin.Expect<T>(controller: T): T
	warnDeprecated(
		"the provider itself",
		"`Expect()`",
		"Prvd 'M Wrong can figure out dependencies by specifying it directly."
	)
	return controller
end

return lumin
