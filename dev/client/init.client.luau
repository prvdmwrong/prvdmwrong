-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local script: typeof(ReplicatedStorage.Client) = script

local Shared = ReplicatedStorage.Shared
local prvd = require(Shared.Packages.prvd)

_G.PRVDMWRONG_VERBOSE = true

prvd.root():useModules(script.Providers:GetDescendants()):start()
