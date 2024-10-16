-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local script: typeof(ReplicatedStorage.Shared.core.naming.named) = script

local Shared = ReplicatedStorage.Shared
local prvd = require(Shared.Packages.prvd)

local OLD_NAME = "DoNotRename"

local NamedProvider = {}
type Self = typeof(NamedProvider)
NamedProvider.name = OLD_NAME

function NamedProvider.onInit(self: Self)
	assert(
		NamedProvider.name == OLD_NAME,
		`Root renamed this provider to {NamedProvider.name} even though it is previously {OLD_NAME} (from {script:GetFullName()})`
	)
	print("NamedProvider has kept its name as", NamedProvider.name)
end

return prvd(NamedProvider)
