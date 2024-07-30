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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local prvd = require(script.Packages.prvd)
local lifecycles = {}

type Provider<T> = prvd.Provider<T>
type Self = typeof(lifecycles)
type Set<T> = { [T]: true }

-- TODO: this doesnt profile lifecycle methods yet, ideally ohmyprvd would
-- expose an api for reading ignition config

lifecycles.loadOrder = 0
function lifecycles.init(self: Self)
  local postSimulation: Set<Provider<{ onPostSimulation: (Provider<unknown>, number) -> () }>> = {}
  local preSimulation: Set<Provider<{ onPreSimulation: (Provider<unknown>, number) -> () }>> = {}
  local preRender: Set<Provider<{ onPreRender: (Provider<unknown>, number) -> () }>> = {}

  local playerAdded: Set<Provider<{ onPlayerAdded: (Provider<unknown>, Player) -> () }>> = {}
  local playerLeaving: Set<Provider<{ onPlayerLeaving: (Provider<unknown>, Player) -> () }>> = {}
  local shutdown: Set<Provider<{ onShutdown: (Provider<unknown>) -> () }>> = {}

  local function implementMethod(watchlist: { [unknown]: true }, method: string)
    prvd.onMethodImplemented(method, function(provider)
      watchlist[provider] = true
    end)
  end

  local connections = {}
  implementMethod(postSimulation, "onPostSimulation")
  table.insert(
    connections,
    RunService.PostSimulation:Connect(function(dt)
      for provider in pairs(postSimulation) do
        provider:onPostSimulation(dt)
      end
    end)
  )

  implementMethod(preSimulation, "onPreSimulation")
  table.insert(
    connections,
    RunService.PreSimulation:Connect(function(dt)
      for provider in pairs(preSimulation) do
        provider:onPreSimulation(dt)
      end
    end)
  )

  if RunService:IsClient() then
    implementMethod(preRender, "onPreRender")
    table.insert(
      connections,
      RunService.PreRender:Connect(function(dt)
        for provider in pairs(preRender) do
          provider:onPreRender(dt)
        end
      end)
    )
  end

  implementMethod(playerAdded, "onPlayerAdded")
  table.insert(
    connections,
    Players.PlayerAdded:Connect(function(player)
      for provider in pairs(playerAdded) do
        provider:onPlayerAdded(player)
      end
    end)
  )

  implementMethod(playerLeaving, "onPlayerLeaving")
  table.insert(
    connections,
    Players.PlayerRemoving:Connect(function(player)
      for provider in pairs(playerLeaving) do
        provider:onPlayerLeaving(player)
      end
    end)
  )

  implementMethod(shutdown, "onShutdown")
  local plugin: Plugin? = plugin or script:FindFirstAncestorWhichIsA("Plugin")
  if plugin then
    plugin.Unloading:Once(function()
      for _, connection in pairs(connections) do
        if connection.Connected == false then
          continue
        end
        connection:Disconnect()
      end
      for provider in pairs(shutdown) do
        provider:onShutdown()
      end
    end)
  else
    game:BindToClose(function()
      for provider in pairs(shutdown) do
        provider:onShutdown()
      end
    end)
  end
end

return prvd.new("ohmyprvd-lifecycles", lifecycles)
