--!strict
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Promise = require("lumin-compat/promise") :: PromiseLib
local Signal = require("lumin-compat/signal")
local Types = require("lumin-compat/types")
local log = require("lumin-compat/log")
local prvd = require("lumin-compat/prvd")

export type WorkerType = Types.WorkerType
type PromiseLib = Types.PromiseLib
type Signal = typeof(Signal.new())

local WORKER_TYPES: { [string]: RBXScriptSignal } = {
  PostSimulation = RunService.PostSimulation,
  PreSimulation = RunService.PreSimulation,
  PreAnimation = RunService.PreAnimation,
  PreRender = RunService.PreRender,
  PlayerAdded = Players.PlayerAdded,
  PlayerRemoving = Players.PlayerRemoving,
}

local signals: { [string]: Signal } = {}
local start = Promise.promisify(prvd.start)

local LuminCompat = {}
LuminCompat.Started = prvd.getStartupStatus() ~= prvd.StartupStatus.Pending

prvd.onStart(function()
  LuminCompat.Started = true
end)

function LuminCompat.Controller<T>(name: string, members: T & {}): prvd.Provider<T>
  log.warn("luminDeprecated", "`prvd()`", "`Controller()`", "the former is less verbose and pragmatic")

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
  return members :: any
end

function LuminCompat.Worker(type: WorkerType, callback: (...any) -> ())
  log.warn(
    "luminDeprecated",
    "the `Lifecycle` object or the `@prvdmwrong/lifecycles` package",
    "creating `Worker()`s",
    "lifecycles have furthered customizability and hook onto providers, with the lifecycles package already implementing all workers Lumin Framework offers as lifecycles"
  )

  local signal = log.expect(WORKER_TYPES[type], "luminMissingWorker", type)
  signal:Connect(callback)

  local self = {}
  self.Type = type
  self.IsWorker = true
  self.Callback = callback

  table.freeze(self)
  return self
end

function LuminCompat.Signal(name: string?): Signal
  log.warn(
    "luminDeprecated",
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

function LuminCompat.Start(): Types.Promise
  log.warn("luminDeprecated", "`start()`", "`Start()`", "Prvd 'M Wrong is not promise based")
  return start()
end

return LuminCompat
