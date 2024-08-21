--!strict
-- (c) Prvd 'M Wrong, dual-licensed under Apache 2.0 and MIT terms.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Types = require("prvdmwrong-lifecycles/types")
local prvd = require("prvdmwrong-lifecycles/prvd")

export type OnPreSimulation = Types.OnPreSimulation
export type OnPostSimulation = Types.OnPostSimulation
export type OnPreAnimation = Types.OnPreAnimation
export type OnPreRender = Types.OnPreRender
export type OnShutdown = Types.OnShutdown
export type OnPlayerAdded = Types.OnPlayerAdded
export type OnPlayerRemoving = Types.OnPlayerRemoving
type Lifecycle<Interface = { [any]: any }> = prvd.Lifecycle<Interface>

local Lifecycles = {}
Lifecycles.version = "VERSION"

Lifecycles.preSimulation = prvd.Lifecycle("onPreSimulation", prvd.fireConcurrent) :: Lifecycle<OnPreSimulation>
Lifecycles.postSimulation = prvd.Lifecycle("onPostSimulation", prvd.fireConcurrent) :: Lifecycle<OnPostSimulation>
Lifecycles.preAnimation = prvd.Lifecycle("onPreAnimation", prvd.fireConcurrent) :: Lifecycle<OnPreAnimation>
Lifecycles.preRender = prvd.Lifecycle("onPreRender", prvd.fireConcurrent) :: Lifecycle<OnPreRender>
Lifecycles.shutdown = prvd.Lifecycle("onShutdown", prvd.fireSequential) :: Lifecycle<OnShutdown>
Lifecycles.playerAdded = prvd.Lifecycle("onPlayerAdded", prvd.fireConcurrent) :: Lifecycle<OnPlayerAdded>
Lifecycles.playerRemoving = prvd.Lifecycle("onPlayerRemoving", prvd.fireConcurrent) :: Lifecycle<OnPlayerRemoving>

local function bindLifecycle(lifecycle: Lifecycle)
  return function(...: unknown)
    lifecycle:fire(...)
  end
end

do
  local connections: { RBXScriptConnection } = {}
  Lifecycles.shutdown:register {
    onShutdown = function()
      for _, connection in connections do
        if not connection.Connected then
          continue
        end
        connection:Disconnect()
      end
    end,
  }

  local function addConnection(connection: RBXScriptConnection)
    table.insert(connections, connection)
  end

  addConnection(RunService.PreSimulation:Connect(bindLifecycle(Lifecycles.preSimulation)))
  addConnection(RunService.PostSimulation:Connect(bindLifecycle(Lifecycles.postSimulation)))
  if RunService:IsClient() then
    addConnection(RunService.PreRender:Connect(bindLifecycle(Lifecycles.preRender)))
    addConnection(RunService.PreAnimation:Connect(bindLifecycle(Lifecycles.preAnimation)))
  end

  local plugin: Plugin? = plugin or script:FindFirstAncestorWhichIsA("Plugin")
  if plugin then
    plugin.Unloading:Once(bindLifecycle(Lifecycles.shutdown))
  elseif RunService:IsServer() then
    game:BindToClose(bindLifecycle(Lifecycles.shutdown))
  end
  game.Close:Connect(function() end)

  addConnection(Players.PlayerAdded:Connect(bindLifecycle(Lifecycles.playerAdded)))
  addConnection(Players.PlayerRemoving:Connect(bindLifecycle(Lifecycles.playerRemoving)))
end

table.freeze(Lifecycles)
return Lifecycles
