local fs = require("@lune/fs")
local path = require("@lunescripts/_utils/path")
local process = require("@lune/process")
local serde = require("@lune/serde")
local types = require("@lunescripts/types")

local REPO_CONFIG = path(process.cwd, "prvdmwrong.toml")

local configs = {}

local function getRepoConfig()
	local repoConfig = serde.decode("toml", fs.readFile(REPO_CONFIG))
	assert(types.RepoConfig(repoConfig))
	return repoConfig
end

local ok, repoConfig: types.RepoConfig = pcall(getRepoConfig)
if not ok then
	error("Failed to get prvdmwrong.toml configuration: " .. repoConfig :: any)
end

configs.repoConfig = table.freeze(repoConfig)

table.freeze(configs)
return configs
