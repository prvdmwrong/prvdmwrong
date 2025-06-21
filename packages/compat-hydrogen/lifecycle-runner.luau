local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local prvd = require("../prvdmwrong")

local HydrogenLifecycleRunner = {}
HydrogenLifecycleRunner.name = "@compat-hydrogen/lifecycle-runner"
HydrogenLifecycleRunner.priority = -math.huge
HydrogenLifecycleRunner.playerAdded = prvd.lifecycle("PlayerAdded", prvd.fireConcurrent)
HydrogenLifecycleRunner.playerRemoving = prvd.lifecycle("PlayerRemoving", prvd.fireConcurrent)
HydrogenLifecycleRunner.heartbeat = prvd.lifecycle("Heartbeat", prvd.fireConcurrent)
HydrogenLifecycleRunner.postSimulation = prvd.lifecycle("PostSimulation", prvd.fireConcurrent)
HydrogenLifecycleRunner.preSimulation = prvd.lifecycle("PreSimulation", prvd.fireConcurrent)

HydrogenLifecycleRunner.characterAdded = prvd.lifecycle("CharacterAdded", prvd.fireConcurrent)
HydrogenLifecycleRunner.characterRemoving = prvd.lifecycle("CharacterRemoving", prvd.fireConcurrent)
HydrogenLifecycleRunner.renderStepped = prvd.lifecycle("RenderStepped", prvd.fireConcurrent)

function HydrogenLifecycleRunner.constructor(self: HydrogenLifecycleRunner)
	self.connections = {}

	self:bind(Players.PlayerAdded, self.playerAdded)
	self:bind(Players.PlayerRemoving, self.playerRemoving)
	self:bind(RunService.Heartbeat, self.heartbeat)
	self:bind(RunService.PostSimulation, self.postSimulation)
	self:bind(RunService.PreSimulation, self.preSimulation)

	if RunService:IsClient() then
		local localPlayer = Players.LocalPlayer

		self:bind(localPlayer.CharacterAdded, self.characterAdded)
		self:bind(localPlayer.CharacterRemoving, self.characterRemoving)
		self:bind(RunService.RenderStepped, self.renderStepped)
	end
end

function HydrogenLifecycleRunner.bind(self: HydrogenLifecycleRunner, signal: RBXScriptSignal, lifecycle: prvd.Lifecycle)
	table.insert(
		self.connections,
		signal:Connect(function(...)
			lifecycle:fire(...)
		end)
	)
end

function HydrogenLifecycleRunner.destroy(self: HydrogenLifecycleRunner)
	for _, connection in self.connections do
		if connection.Connected then
			connection:Disconnect()
		end
	end
end

export type HydrogenLifecycleRunner = typeof(HydrogenLifecycleRunner)
return prvd(HydrogenLifecycleRunner)
