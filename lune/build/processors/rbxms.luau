local fs = require("@lune/fs")
local path = require("@lunescripts/utils/path")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local summon = require("@lunescripts/utils/summon")
local types = require("@lunescripts/types")

local bundle = roblox.Instance.new("Folder")
bundle.Name = "Prvd 'M Wrong Bundle"

local bundledModels: { roblox.Instance } = {}

local RobloxModels = {} :: types.BuildProcessor
RobloxModels.loadOrder = 2

function RobloxModels:process(package: types.BuildPackage)
	local project = {}
	project.name = package.name
	project.tree = {
		["$path"] = "src",
	}

	local projectPath = path(package.outputPath, "default.project.json")
	local modelPath = path(process.cwd, "build", package.name .. ".rbxm")

	print("  Writing default.project.json")
	fs.writeFile(projectPath, serde.encode("json", project))
	print("  Writing Roblox model")
	summon("rojo", "build", "-o", modelPath, projectPath)

	print("  Adding to bundle")
	for _, instance in roblox.deserializeModel(fs.readFile(modelPath)) do
		print("    Adding instance", instance:GetFullName())
		table.insert(bundledModels, instance)
	end
end

function RobloxModels:postProcessing()
	print("Creating bundled Roblox model")
	for _, model in bundledModels do
		print("  Parenting", model:GetFullName())
		model.Parent = bundle
	end

	print("Writing bundled Roblox model")
	fs.writeFile(path(process.cwd, "build", "bundle.rbxm"), roblox.serializeModel({ bundle }))
end

return RobloxModels
