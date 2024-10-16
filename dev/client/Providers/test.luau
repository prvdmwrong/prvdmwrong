-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local prvd = require(Shared.Packages.prvd)

local TestProvider = {}
type Self = typeof(TestProvider)

function TestProvider.onInit(self: Self)
	print("Hello world!")
end

return prvd(TestProvider)
