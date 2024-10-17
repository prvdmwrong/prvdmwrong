-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local prvd = require(ReplicatedStorage.Packages.prvd)

_G.PRVDMWRONG_VERBOSE = true

-- RunContext is weird
if _G.HAS_RUN then
	return
end

_G.HAS_RUN = true :: any
print("Starting server root...")
local root = prvd.root():useModules(ReplicatedStorage.Specs.core:GetDescendants()):start()

task.wait(4)

print("Stopping server root...")
root:stop()
