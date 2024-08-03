--!strict
--!nolint LocalShadow
-- Oh My Prvd code licensed under MIT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local prvd = require(script.Packages.prvd)
local lifecycles = {}

type Pack = { [number]: any, n: number }
type Provider<T> = prvd.Provider<T>
type Self = typeof(lifecycles)
type Set<T> = { [T]: true }

local freeThreads: { thread } = {}

local function yield()
  while true do
    local pack: Pack = table.pack(coroutine.yield())
    local resume: (...any) -> (), thread: thread = table.unpack(pack, 1, 2)
    resume(table.unpack(pack, 3, pack.n))
    table.insert(freeThreads, thread)
  end
end

--[[
  Spawns a thread immediately. This will pool and reuse threads when possible,
  and thus is more efficient than `task.spawn`.
]]
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

-- TODO: this doesnt profile lifecycle methods yet, ideally ohmyprvd would
-- expose an api for reading ignition config

lifecycles.loadOrder = 0
function lifecycles:onInit()
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

  implementMethod(playerLeaving, "onPlayerLeaving")
  table.insert(
    connections,
    Players.PlayerRemoving:Connect(function(player)
      for provider in pairs(playerLeaving) do
        spawn(provider.onPlayerLeaving, provider, player)
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
