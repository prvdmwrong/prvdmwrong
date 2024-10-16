-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local prvd = require(Shared.Packages.prvd)

local LoadOrderProvider = {}
type Self = typeof(LoadOrderProvider)
LoadOrderProvider.loadOrder = 0

function LoadOrderProvider.onInit(self: Self)
	print("This should load before every other provider")
end

return prvd(LoadOrderProvider)
