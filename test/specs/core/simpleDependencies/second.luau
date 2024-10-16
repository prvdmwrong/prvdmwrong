-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Specs = ReplicatedStorage.Specs
local FirstProvider = require(Specs.core.simpleDependencies.first)
local prvd = require(ReplicatedStorage.Packages.prvd)

local SecondProvider = {}
type Self = typeof(SecondProvider)
SecondProvider.firstProvider = FirstProvider
SecondProvider.initialized = false

function SecondProvider.onInit(self: Self)
	assert(self.firstProvider.initialized, "SecondProvider initialized before FirstProvider")
	print("Initializing SecondProvider...")
	self.initialized = true
end

return prvd(SecondProvider)
