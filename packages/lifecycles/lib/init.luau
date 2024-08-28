--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local prvd = require("lifecycles/utils/prvd")

export type OnPreSimulation = {
	onPreSimulation: (self: prvd.Provider<unknown>, number) -> (),
}

export type OnPostSimulation = {
	onPostSimulation: (self: prvd.Provider<unknown>, number) -> (),
}

export type OnPreAnimation = {
	onPreAnimation: (self: prvd.Provider<unknown>, number) -> (),
}

export type OnPreRender = {
	onPreRender: (self: prvd.Provider<unknown>, number) -> (),
}

export type OnShutdown = {
	onShutdown: (self: prvd.Provider<unknown>) -> (),
}

export type OnPlayerAdded = {
	onPlayerAdded: (self: prvd.Provider<unknown>, Player) -> (),
}

export type OnPlayerRemoving = {
	onPlayerRemoving: (self: prvd.Provider<unknown>, Player) -> (),
}

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
