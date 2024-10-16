local fs = require("@lune/fs")
local path = require("@scripts/_utils/path")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local summon = require("@scripts/_utils/summon")
local types = require("@scripts/build/types")

local BUILD_DIRECTORY = path(process.cwd, "build")

local Instance: typeof(Instance) = roblox.Instance :: any

local RobloxModelProcessor = {} :: types.Processor
RobloxModelProcessor.processesWhat = "Roblox .rbxms models"

local bundle = Instance.new("Model")
bundle.Name = "Prvd 'M Wrong Bundle"

function RobloxModelProcessor:process(package: types.Package, context: types.BuildContext)
	local modelPath = path(BUILD_DIRECTORY, `prvdmwrong-{package.packageName}.rbxm`)
	summon("rojo", "build", "-o", modelPath, path(package.outputPath, "default.project.json"))

	local modelInstances = roblox.deserializeModel(fs.readFile(modelPath)) :: { Instance }
	for _, instance in modelInstances do
		instance.Parent = bundle
	end
end

function RobloxModelProcessor:postProcess()
	fs.writeFile(path(BUILD_DIRECTORY, "bundle.rbxm"), roblox.serializeModel({ bundle :: any }))
end

return RobloxModelProcessor
