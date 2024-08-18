--!strict
--[[
  Copyright (c) znotfireman 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Prvd = require("prvdmwrong-lifecycles/prvd")
local Types = require("prvdmwrong-lifecycles/Types")
local Lifecycle = Prvd.Lifecycle

export type OnPreSimulation = Types.OnPreSimulation
export type OnPostSimulation = Types.OnPostSimulation
export type OnPreAnimation = Types.OnPreAnimation
export type OnPreRender = Types.OnPreRender
export type OnShutdown = Types.OnShutdown
export type OnPlayerAdded = Types.OnPlayerAdded
export type OnPlayerRemoving = Types.OnPlayerRemoving
type Lifecycle<Interface = { [any]: any }> = Prvd.Lifecycle<Interface>

local Lifecycles = {}
Lifecycles.preSimulation = Lifecycle("onPreSimulation", Prvd.fireConcurrent) :: Lifecycle<OnPreSimulation>
Lifecycles.postSimulation = Lifecycle("onPostSimulation", Prvd.fireConcurrent) :: Lifecycle<OnPostSimulation>
Lifecycles.preAnimation = Lifecycle("onPreAnimation", Prvd.fireConcurrent) :: Lifecycle<OnPreAnimation>
Lifecycles.preRender = Lifecycle("onPreRender", Prvd.fireConcurrent) :: Lifecycle<OnPreRender>
Lifecycles.shutdown = Lifecycle("onShutdown", Prvd.fireSequential) :: Lifecycle<OnShutdown>
Lifecycles.playerAdded = Lifecycle("onPlayerAdded", Prvd.fireConcurrent) :: Lifecycle<OnPlayerAdded>
Lifecycles.playerRemoving = Lifecycle("onPlayerRemoving", Prvd.fireConcurrent) :: Lifecycle<OnPlayerRemoving>

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

  addConnection(Players.PlayerAdded:Connect(bindLifecycle(Lifecycles.playerAdded)))
  addConnection(Players.PlayerRemoving:Connect(bindLifecycle(Lifecycles.playerRemoving)))
end

table.freeze(Lifecycles)
return Lifecycles
