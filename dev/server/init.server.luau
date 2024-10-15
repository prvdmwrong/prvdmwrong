-- FIXME(znotfireman): Luau is very janky
local game: DataModel = game
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local script: typeof(game:GetService("ServerScriptService").Server) = script

local Shared = ReplicatedStorage.Shared
local prvd = require(Shared.Packages.prvd)

_G.PRVDMWRONG_VERBOSE = true

local root = prvd.root():useModules(script.Providers:GetDescendants()):start()
