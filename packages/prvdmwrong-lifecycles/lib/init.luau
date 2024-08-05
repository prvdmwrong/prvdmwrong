--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local prvd = assert(_G.prvdmwrong, "Cannot acquire core package") :: Prvd
local types = require(script.types)

export type OnPreSimulation = types.OnPreSimulation
export type OnPostSimulation = types.OnPostSimulation
export type OnPreRender = types.OnPreRender
export type OnShutdown = types.OnShutdown
export type OnPlayerAdded = types.OnPlayerAdded
export type OnPlayerRemoving = types.OnPlayerRemoving
type Pack = { [number]: any, n: number }
type Provider<T> = types.Provider<T>
type Prvd = types.Prvd
type Set<T> = { [T]: true }

local freeThreads: { thread } = {}

local Lifecycles = {}
type Self = typeof(Lifecycles)

local function yield()
  while true do
    local pack: Pack = table.pack(coroutine.yield())
    local resume: (...any) -> (), thread: thread = table.unpack(pack, 1, 2)
    resume(table.unpack(pack, 3, pack.n))
    table.insert(freeThreads, thread)
  end
end

local function spawn<Args...>(resume: (Args...) -> (), ...: Args...)
  local thread: thread
  if #freeThreads > 0 then
    thread = assert(table.remove(freeThreads, #freeThreads), "Luau")
  else
    thread = coroutine.create(yield)
    coroutine.resume(thread)
  end
  task.spawn(thread, resume, thread, ...)
end

Lifecycles.loadOrder = 0
function Lifecycles:onInit()
  local postSimulation: Set<Provider<OnPostSimulation>> = {}
  local preSimulation: Set<Provider<OnPreSimulation>> = {}
  local preRender: Set<Provider<OnPreRender>> = {}

  local playerAdded: Set<Provider<OnPlayerAdded>> = {}
  local playerRemoving: Set<Provider<OnPlayerRemoving>> = {}
  local shutdown: Set<Provider<OnShutdown>> = {}

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
        spawn(provider.onPostSimulation, provider, dt)
      end
    end)
  )

  implementMethod(preSimulation, "onPreSimulation")
  table.insert(
    connections,
    RunService.PreSimulation:Connect(function(dt)
      for provider in pairs(preSimulation) do
        spawn(provider.onPreSimulation, provider, dt)
      end
    end)
  )

  if RunService:IsClient() then
    implementMethod(preRender, "onPreRender")
    table.insert(
      connections,
      RunService.PreRender:Connect(function(dt)
        for provider in pairs(preRender) do
          spawn(provider.onPreRender, provider, dt)
        end
      end)
    )
  end

  implementMethod(playerAdded, "onPlayerAdded")
  table.insert(
    connections,
    Players.PlayerAdded:Connect(function(player)
      for provider in pairs(playerAdded) do
        spawn(provider.onPlayerAdded, provider, player)
      end
    end)
  )

  implementMethod(playerRemoving, "onPlayerRemoving")
  table.insert(
    connections,
    Players.PlayerRemoving:Connect(function(player)
      for provider in pairs(playerRemoving) do
        spawn(provider.onPlayerRemoving, provider, player)
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

prvd.new("prvdmwrong@Lifecycles", Lifecycles)
return nil
