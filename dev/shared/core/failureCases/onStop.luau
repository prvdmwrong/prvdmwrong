-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local prvd = require(Shared.Packages.prvd)

local OnStopProvider = {}
type Self = typeof(OnStopProvider)
OnStopProvider.loadOrder = -math.huge

function OnStopProvider.onStop(self: Self)
	print("Now stopping providers...")
end

return prvd(OnStopProvider)
