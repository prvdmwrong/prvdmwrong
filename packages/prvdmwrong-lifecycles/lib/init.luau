--!strict
--[[
  Copyright (c) znotfireman 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local prvd = require("lifecycles/prvd")
local types = require("lifecycles/types")
local Lifecycle = prvd.Lifecycle
local fireConcurrent = prvd.fireConcurrent
local fireSequential = prvd.fireSequential

export type OnPreSimulation = types.OnPreSimulation
export type OnPostSimulation = types.OnPostSimulation
export type OnPreAnimation = types.OnPreAnimation
export type OnPreRender = types.OnPreRender
export type OnShutdown = types.OnShutdown
export type OnPlayerAdded = types.OnPlayerAdded
export type OnPlayerRemoving = types.OnPlayerRemoving
type Lifecycle<Interface = { [any]: any }> = prvd.Lifecycle<Interface>
type Set<T> = { [T]: true }

local preSimulation: Lifecycle<OnPreSimulation> = Lifecycle("onPreSimulation", fireConcurrent)
local postSimulation: Lifecycle<OnPostSimulation> = Lifecycle("onPostSimulation", fireConcurrent)
local preAnimation: Lifecycle<OnPreAnimation> = Lifecycle("onPreAnimation", fireConcurrent)
local preRender: Lifecycle<OnPreRender> = Lifecycle("onPreRender", fireConcurrent)
local shutdown: Lifecycle<OnShutdown> = Lifecycle("onShutdown", fireSequential)
local playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", fireConcurrent)
local playerRemoving: Lifecycle<OnPlayerRemoving> = Lifecycle("onPlayerRemoving", fireConcurrent)

local function bindLifecycle(lifecycle: Lifecycle)
  return function(...: unknown)
    lifecycle:fire(...)
  end
end

do
  local connections: { RBXScriptConnection } = {}
  shutdown:register {
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

  addConnection(RunService.PreSimulation:Connect(bindLifecycle(preSimulation)))
  addConnection(RunService.PostSimulation:Connect(bindLifecycle(postSimulation)))
  if RunService:IsClient() then
    addConnection(RunService.PreRender:Connect(bindLifecycle(preRender)))
    addConnection(RunService.PreAnimation:Connect(bindLifecycle(preAnimation)))
  end

  local plugin: Plugin? = plugin or script:FindFirstAncestorWhichIsA("Plugin")
  if plugin then
    plugin.Unloading:Once(bindLifecycle(shutdown))
  else
    game:BindToClose(bindLifecycle(shutdown))
  end

  addConnection(Players.PlayerAdded:Connect(bindLifecycle(playerAdded)))
  addConnection(Players.PlayerRemoving:Connect(bindLifecycle(playerRemoving)))
end

return nil
