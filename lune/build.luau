local StringBuilder = require("@scripts/_builders/string-builder")
local configs = require("@scripts/_configs")
local fs = require("@lune/fs")
local packages = require("@scripts/packages")
local path = require("@scripts/_utils/path")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local summon = require("@scripts/_utils/summon")
local types = require("@scripts/_types")

type Set<T> = { [T]: true }
type BrokenLuau = never
type Build = {
	packages: string,
	models: string,
	work: string,

	darklua: string,

	robloxBundle: roblox.Instance,
}

local BUILD_DIRECTORY = path(process.cwd, "build")
local BASE_DARKLUA_CONFIG = path(process.cwd, "darklua.json")

local Instance = roblox.Instance
local publishConfig = configs.repoConfig.publish

local function setupBuild(): Build
	if fs.isDir(BUILD_DIRECTORY) :: BrokenLuau then
		for _, file in fs.readDir(BUILD_DIRECTORY) do
			local filepath = path(BUILD_DIRECTORY, file)
			if fs.isFile(filepath) :: BrokenLuau then
				fs.removeFile(filepath)
			elseif fs.isDir(filepath) :: BrokenLuau then
				fs.removeDir(filepath)
			end
		end
	else
		fs.writeDir(BUILD_DIRECTORY)
	end

	local packagesDir = path(BUILD_DIRECTORY, "packages")
	local modelsDir = path(BUILD_DIRECTORY, "models")
	local workDir = path(BUILD_DIRECTORY, "work")

	local darkluaConfig = serde.decode("json", fs.readFile(BASE_DARKLUA_CONFIG))
	local buildDarklua = path(workDir, "darklua.json")

	local sources = {}
	for _, package in packages do
		sources["@" .. package.packageName] = path(package.absolutePath, "src")
	end

	local bundle = Instance.new("Folder")
	bundle.Name = "Prvd 'M Wrong Bundle"

	table.insert(darkluaConfig.rules, 1, {
		rule = "convert_require",
		current = {
			name = "path",
			sources = sources,
		},
		target = {
			name = "roblox",
			indexing_style = "property",
			rojo_sourcemap = "../../sourcemap.json",
		},
	})

	fs.writeDir(packagesDir)
	fs.writeDir(modelsDir)
	fs.writeDir(workDir)
	fs.writeFile(buildDarklua, serde.encode("json", darkluaConfig))

	return {
		packages = packagesDir,
		models = modelsDir,
		work = workDir,

		darklua = buildDarklua,

		robloxBundle = bundle,
	}
end

local function pesdeify(str: string)
	return (str:gsub("-", "_"))
end

local nameToPackage: { [string]: types.Package } = {}

-- Dependencies need to be published before dependent packages are, thus resolve
-- these dependencies through topological sorting
local function resolveDependencies(): { types.Package }
	local visited: Set<types.Package> = {}
	local resolved: { types.Package } = {}

	local function resolvePackage(package: types.Package)
		if visited[package] then
			return
		end
		visited[package] = true

		local dependencies = package.config.config.dependencies
		if dependencies then
			for _, dependentName in dependencies do
				local dependentPackage = nameToPackage[dependentName]
				if dependentPackage and not visited[dependentPackage] then
					resolvePackage(dependentPackage)
				end
			end
		end

		table.insert(resolved, package)
	end

	for _, package in packages do
		resolvePackage(package)
	end

	return resolved
end

local build = setupBuild()

for _, package in resolveDependencies() do
	print("Building", package.packageName)
	local workingDirectory = path(build.packages, package.packageName)

	fs.writeDir(workingDirectory)

	summon("rojo", "sourcemap", "-o", "sourcemap.json", "default.project.json")

	local darkluaResult = process.spawn(
		"darklua",
		{ "process", "-c", build.darklua, path(package.absolutePath, "src"), path(workingDirectory, "src") },
		{
			cwd = process.cwd,
			env = {
				PRVDMWRONG_VERSION = publishConfig.version,
			},
		} :: process.SpawnOptions
	)

	if not darkluaResult.ok then
		print(darkluaResult.stdout)
		print(darkluaResult.stderr)
		print("Darklua failed with code", tostring(darkluaResult.code))
		return process.exit(darkluaResult.code) :: any
	end

	fs.copy(path(process.cwd, "LICENSE-APACHE.md"), path(workingDirectory, "LICENSE-APACHE.md"))
	fs.copy(path(process.cwd, "LICENSE-MIT.md"), path(workingDirectory, "LICENSE-MIT.md"))

	fs.writeFile(
		path(workingDirectory, "default.project.json"),
		serde.encode("json", {
			name = package.packageName,
			tree = {
				["$path"] = "src",
			},
		})
	)

	local wallyDependencies = {}
	local pesdeDependencies = {}
	local npmDependencies = {}

	if package.config.config.dependencies then
		for _, dependency in package.config.config.dependencies do
			pesdeDependencies[dependency] = {
				name = pesdeify(`{publishConfig.scopes.pesde}/{dependency}`),
				version = publishConfig.version,
				target = "roblox",
			}

			wallyDependencies[dependency] = `{publishConfig.scopes.wally}/{dependency}@{publishConfig.version}`
			npmDependencies[`{publishConfig.scopes.npm}/{dependency}`] = `^{publishConfig.version}`
		end
	end

	local wallyConfig = {
		package = {
			name = `{publishConfig.scopes.wally}/{package.packageName}`,
			version = publishConfig.version,
			description = package.config.config.description,
			license = publishConfig.license,
			authors = publishConfig.authors,
			realm = "shared",
			registry = "https://github.com/UpliftGames/wally-index",
		},
		dependencies = wallyDependencies,
	}

	local pesdeConfig = {
		name = pesdeify(`{publishConfig.scopes.pesde}/{package.packageName}`),
		version = publishConfig.version,
		description = package.config.config.description,
		license = publishConfig.license,
		authors = publishConfig.authors,
		repository = publishConfig.repository,
		exports = {
			lib = "./init.luau",
		},
		dependencies = pesdeDependencies,
		target = {
			environment = "roblox",
			lib = "src/init.luau",
		},
		indices = {
			default = "https://github.com/daimond113/pesde-index",
		},
	}

	local npmConfig = {
		name = `@{publishConfig.scopes.npm}/{package.packageName}`,
		description = package.config.config.description,
		version = publishConfig.version,
		author = publishConfig.authors[1],
		license = publishConfig.license,
		main = "src/init.luau",
		types = "src/index.d.ts",
		files = {
			"src",
			"default.project.json",
			"LICENSE-APACHE.md",
			"LICENSE-MIT.md",
			"README.md",
			"!**/*.tsbuildinfo",
		},
		publishConfig = {
			access = "public",
		},
		dependencies = npmDependencies,
		devDependencies = {
			["@rbxts/compiler-types"] = "2.3.0-types.1",
			["@rbxts/types"] = "^1.0.790",
			["roblox-ts"] = "^2.3.0",
			typescript = "^5.5.4",
		},
	}

	fs.writeFile(path(workingDirectory, "wally.toml"), serde.encode("toml", wallyConfig))
	fs.writeFile(path(workingDirectory, "pesde.toml"), serde.encode("toml", pesdeConfig))
	fs.writeFile(path(workingDirectory, "package.json"), serde.encode("json", npmConfig))

	local existingReadme = path(package.absolutePath, "README.md")
	if fs.isFile(existingReadme) :: BrokenLuau then
		fs.copy(existingReadme, path(workingDirectory, "README.md"))
	else
		fs.writeFile(
			path(workingDirectory, "README.md"),
			StringBuilder()
				:appendLn("#", package.config.config.name)
				:appendLn()
				:appendLn(package.config.docs.overview)
				:appendLn()
				:appendLn(
					`Learn more in the [documentation](https://prvdmwrong.github.io/prvdmwrong/0.2/api-reference/{package.packageName}).`
				)
				:appendLn("This package is part of [Prvd 'M Wrong](https://github.com/prvdmwrong/prvdmwrong)")
				:build()
		)
	end

	local modelPath = path(build.models, package.packageName .. ".rbxm")
	summon("rojo", "build", "-o", modelPath, workingDirectory)

	local model = roblox.deserializeModel(fs.readFile(modelPath))
	for _, instance in model do
		instance.Parent = build.robloxBundle
	end
end

fs.writeFile(path(BUILD_DIRECTORY, "prvdmwrong.rbxm"), roblox.serializeModel({ build.robloxBundle }))

local game = Instance.new("DataModel" :: "DataModel")
build.robloxBundle.Parent = game:GetService("ReplicatedStorage")
build.robloxBundle.Name = "Packages"

for _, package in packages do
	assert(build.robloxBundle:FindFirstChild(package.packageName), "Unreachable").Name = package.config.config.module
end

fs.writeFile(path(BUILD_DIRECTORY, "prvdmwrong.rbxl"), roblox.serializePlace(game))
