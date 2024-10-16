-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local FirstProvider = require(Shared.core.simpleDependencies.first)
local SecondProvider = require(Shared.core.simpleDependencies.second)
local prvd = require(Shared.Packages.prvd)

local ThirdProvider = {}
type Self = typeof(ThirdProvider)
ThirdProvider.firstProvider = FirstProvider
ThirdProvider.secondProvider = SecondProvider
ThirdProvider.initialized = false

function ThirdProvider.onInit(self: Self)
	assert(self.firstProvider.initialized, "ThirdProvider initialized before FirstProvider")
	assert(self.secondProvider.initialized, "ThirdProvider initialized before SecondProvider")
	print("Initializing ThirdProvider...")
	self.initialized = true
end

return prvd(ThirdProvider)
