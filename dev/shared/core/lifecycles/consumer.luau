-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local prvd = require(Shared.Packages.prvd)

local maxTime = 2
local hasStopped = false

local TickConsumer = {}
type Self = typeof(TickConsumer)
TickConsumer.timeElapsed = 0

function TickConsumer.onInit(self: Self)
	self.timeElapsed = 0
	hasStopped = false
	print("Listening to onTick lifecycle...")
end

function TickConsumer.onTick(self: Self, dt: number)
	if self.timeElapsed >= maxTime then
		if not hasStopped then
			print("Exhausted max time of", maxTime, "seconds...")
		end
		hasStopped = true
		return
	end
	self.timeElapsed += dt
	print("Time elapsed:", tostring(math.round(self.timeElapsed * 100) / 100) .. "s")
end

return prvd(TickConsumer)
