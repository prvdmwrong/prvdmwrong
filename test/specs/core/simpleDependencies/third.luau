-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Specs = ReplicatedStorage.Specs
local FirstProvider = require(Specs.core.simpleDependencies.first)
local SecondProvider = require(Specs.core.simpleDependencies.second)
local prvd = require(ReplicatedStorage.Packages.prvd)

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
