local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lifecycles = require("./lifecycles")

local fireConcurrent = lifecycles.handlers.fireConcurrent

local RbxLifecycles = {}
RbxLifecycles.name = "@prvdmwrong/rbx-lifecycles"
RbxLifecycles.priority = -math.huge

RbxLifecycles.preSimulation = lifecycles.create("preSimulation", fireConcurrent) :: lifecycles.Lifecycle<number>
RbxLifecycles.postSimulation = lifecycles.create("postSimulation", fireConcurrent) :: lifecycles.Lifecycle<number>
RbxLifecycles.preAnimation = lifecycles.create("preAnimation", fireConcurrent) :: lifecycles.Lifecycle<number>
RbxLifecycles.preRender = lifecycles.create("preRender", fireConcurrent) :: lifecycles.Lifecycle<number>
RbxLifecycles.playerAdded = lifecycles.create("playerAdded", fireConcurrent) :: lifecycles.Lifecycle<Player>
RbxLifecycles.playerRemoving = lifecycles.create("playerRemoving", fireConcurrent) :: lifecycles.Lifecycle<Player>

local function wrapLifecycle(lifecycle: lifecycles.Lifecycle<...unknown>)
	return function(...: unknown)
		lifecycle:fire(...)
	end
end

function RbxLifecycles.new(self: RbxLifecycles)
	self.connections = {} :: { RBXScriptConnection }
	self:_addConnections(
		RunService.PreSimulation:Connect(wrapLifecycle(self.preSimulation :: any)),
		RunService.PostSimulation:Connect(wrapLifecycle(self.postSimulation :: any)),
		RunService.PreAnimation:Connect(wrapLifecycle(self.preAnimation :: any))
	)

	if RunService:IsClient() then
		self:_addConnections(RunService.PreRender:Connect(wrapLifecycle(self.preRender :: any)))
	end

	self:_addConnections(
		Players.PlayerAdded:Connect(wrapLifecycle(self.playerAdded :: any)),
		Players.PlayerRemoving:Connect(wrapLifecycle(self.playerRemoving :: any))
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

export type RbxLifecycles = typeof(RbxLifecycles)
return RbxLifecycles
