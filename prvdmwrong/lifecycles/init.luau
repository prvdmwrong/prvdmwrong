-- FIXME: Luau is very janky
local game: DataModel = game
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- FIXME: this isnt going to ever work
local prvd = require("@core")

local connections: { RBXScriptConnection } = {}
local function addConnections(...: RBXScriptConnection)
	for index = 1, select("#", ...) do
		table.insert(connections, select(index, ...) :: any)
	end
end

local lifecycles = {}
type Self = typeof(lifecycles)
lifecycles.name = "@prvdmwrong/lifecycles"
lifecycles.version = _G.PRVDMWRONG_VERSION
lifecycles.loadOrder = -math.huge

lifecycles.preSimulation = prvd.lifecycle("onPreSimulation", prvd.fireConcurrent) :: prvd.Lifecycle<number>
lifecycles.postSimulation = prvd.lifecycle("onPostSimulation", prvd.fireConcurrent) :: prvd.Lifecycle<number>
lifecycles.preAnimation = prvd.lifecycle("onPreAnimation", prvd.fireConcurrent) :: prvd.Lifecycle<number>
lifecycles.preRender = prvd.lifecycle("onPreRender", prvd.fireConcurrent) :: prvd.Lifecycle<number>
lifecycles.playerAdded = prvd.lifecycle("onPlayerAdded", prvd.fireConcurrent) :: prvd.Lifecycle<Player>
lifecycles.playerRemoving = prvd.lifecycle("onPlayerRemoving", prvd.fireConcurrent) :: prvd.Lifecycle<Player>

local function bindLifecycle(lifecycle: prvd.Lifecycle<...unknown>)
	return function(...: unknown)
		lifecycle:fire(...)
	end
end

function lifecycles.onInit(self: Self)
	addConnections(
		RunService.PreSimulation:Connect(bindLifecycle(self.preSimulation :: any)),
		RunService.PostSimulation:Connect(bindLifecycle(self.postSimulation :: any)),
		RunService.PreAnimation:Connect(bindLifecycle(self.preAnimation :: any))
	)

	if RunService:IsClient() :: never then
		addConnections(RunService.PreRender:Connect(bindLifecycle(self.preRender :: any)))
	end

	addConnections(
		Players.PlayerAdded:Connect(bindLifecycle(self.playerAdded :: any)),
		Players.PlayerRemoving:Connect(bindLifecycle(self.playerRemoving :: any))
	)
end

function lifecycles.onStop(self: Self)
	for _, connection in connections do
		if connection.Connected then
			connection:Disconnect()
		end
	end
end

return prvd(lifecycles)
