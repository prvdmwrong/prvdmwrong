-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local prvd = require(Shared.Packages.prvd)

_G.PRVDMWRONG_VERBOSE = true

-- RunContext is weird
if _G.HAS_RUN then
	return
end

_G.HAS_RUN = true :: any
print("Starting server root...")
prvd.root():useModules(ReplicatedStorage.Shared.core:GetDescendants()):start()
