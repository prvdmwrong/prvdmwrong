-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local script: typeof(ReplicatedStorage.Client.core.naming.unnamed) = script

local Shared = ReplicatedStorage.Shared
local prvd = require(Shared.Packages.prvd)

local UnnamedProvider = {}
type Self = typeof(UnnamedProvider)
UnnamedProvider.name = nil :: any

function UnnamedProvider.onInit(self: Self)
	assert(
		UnnamedProvider.name == script.Name,
		`Root did not rename this provider to {script.Name} (from {script:GetFullName()})`
	)

	print("UnnamedProvider has been named", UnnamedProvider.name)
end

return prvd(UnnamedProvider)
