-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage.Shared
local prvd = require(Shared.Packages.prvd)

local TickProvider = {}
type Self = typeof(TickProvider)
TickProvider.loadOrder = 0
TickProvider.onTick = prvd.lifecycle("onTick", prvd.fireConcurrent) :: prvd.Lifecycle<number>

function TickProvider.onInit(self: Self)
	self.conn = RunService.Heartbeat:Connect(function(dt)
		self.onTick:fire(dt)
	end)
end

function TickProvider.onStop(self: Self)
	self.onTick:unregisterAll()
end

return prvd(TickProvider)
