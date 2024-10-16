-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Client, Shared = ReplicatedStorage.Client, ReplicatedStorage.Shared
local FirstProvider = require(Client.core.simpleDependencies.first)
local prvd = require(Shared.Packages.prvd)

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
