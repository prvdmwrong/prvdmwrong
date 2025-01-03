-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local prvd = require(ReplicatedStorage.Packages.prvd)

local LoadOrderProvider = {}
type Self = typeof(LoadOrderProvider)
LoadOrderProvider.loadOrder = -math.huge

function LoadOrderProvider.onInit(self: Self)
	print("This should load before every other provider")
end

return prvd(LoadOrderProvider)
