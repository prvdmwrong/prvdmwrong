local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local prvd = require("./prvdmwrong")

local fireConcurrent = prvd.fireConcurrent

local RbxLifecycles = {}
RbxLifecycles.name = "@prvdmwrong/rbx-lifecycles"
RbxLifecycles[prvd.priority] = -math.huge

RbxLifecycles.preSimulation = prvd.lifecycle("preSimulation", fireConcurrent) :: prvd.Lifecycle<number>
RbxLifecycles.postSimulation = prvd.lifecycle("postSimulation", fireConcurrent) :: prvd.Lifecycle<number>
RbxLifecycles.preAnimation = prvd.lifecycle("preAnimation", fireConcurrent) :: prvd.Lifecycle<number>
RbxLifecycles.preRender = prvd.lifecycle("preRender", fireConcurrent) :: prvd.Lifecycle<number>
RbxLifecycles.playerAdded = prvd.lifecycle("playerAdded", fireConcurrent) :: prvd.Lifecycle<Player>
RbxLifecycles.playerRemoving = prvd.lifecycle("playerRemoving", fireConcurrent) :: prvd.Lifecycle<Player>

local function wrapLifecycle(lifecycle: prvd.Lifecycle<...unknown>)
	return function(...: unknown)
		lifecycle:fire(...)
	end
end

function RbxLifecycles.constructor(self: RbxLifecycles)
	self.connections = {} :: { RBXScriptConnection }

	self:_addConnections(
		RunService.PreSimulation:Connect(wrapLifecycle(RbxLifecycles.preSimulation :: any)),
		RunService.PostSimulation:Connect(wrapLifecycle(RbxLifecycles.postSimulation :: any)),
		RunService.PreAnimation:Connect(wrapLifecycle(RbxLifecycles.preAnimation :: any))
	)

	if RunService:IsClient() then
		self:_addConnections(RunService.PreRender:Connect(wrapLifecycle(RbxLifecycles.preRender :: any)))
	end

	self:_addConnections(
		Players.PlayerAdded:Connect(wrapLifecycle(RbxLifecycles.playerAdded :: any)),
		Players.PlayerRemoving:Connect(wrapLifecycle(RbxLifecycles.playerRemoving :: any))
	)
end

function RbxLifecycles.finish(self: RbxLifecycles)
	for _, connection in self.connections do
		if connection.Connected then
			connection:Disconnect()
		end
	end
	table.clear(self.connections)
end

function RbxLifecycles._addConnections(self: RbxLifecycles, ...: RBXScriptConnection)
	for index = 1, select("#", ...) do
		table.insert(self.connections, select(index, ...) :: any)
	end
end

-- Needed so typescript can require the provider as:
--
-- ```ts
-- import { RbxLifecycles } from "@rbxts/rbx-lifecycles"
-- ```
RbxLifecycles.RbxLifecycles = RbxLifecycles

export type RbxLifecycles = typeof(RbxLifecycles)
return prvd(RbxLifecycles)
