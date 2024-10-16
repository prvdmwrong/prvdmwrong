-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local prvd = require(Shared.Packages.prvd)

local FirstProvider = {}
type Self = typeof(FirstProvider)
FirstProvider.initialized = false

function FirstProvider.onInit(self: Self)
	print("Initializing FirstProvider...")
	self.initialized = true
end

return prvd(FirstProvider)
