local collectPackages = require("@lune-lib/utils/collect-packages")
local fs = require("@lune/fs")
local path = require("@lune-lib/utils/path")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local rootConfig = require("@lune-lib/root-config")
local selectPackages = require("@lune-lib/utils/select-packages")
local serde = require("@lune/serde")
local types = require("@lune-lib/types")

local packages = selectPackages(collectPackages(process.cwd, rootConfig.packageDir))
local _, nameToPackage, toBuild = packages.names, packages.nameToPackage, packages.selected

local distPath = path(process.cwd, "dist")
local distPesdePath = path(distPath, "pesde")
local distWallyPath = path(distPath, "wally")
local distNpmPath = path(distPath, "npm")
local distModelPath = path(distPath, "models")
local distTempPath = path(distPath, "temp")
local distBundlePath = path(distPath, "bundle.rbxm")
local distBundlePlacePath = path(distPath, "bundle.rbxl")

if fs.isDir(distPath) then
	fs.removeDir(distPath)
end

fs.writeDir(distPath)
fs.writeDir(distPesdePath)
fs.writeDir(distWallyPath)
fs.writeDir(distNpmPath)
fs.writeDir(distModelPath)
fs.writeDir(distTempPath)

local function copyPackageDir(package: types.Package, destinationDir: string)
	for _, file in fs.readDir(package.absolutePath) do
		if fs.isFile(file) then
			if not file:match("%.luau$") or file == "prvd.config.luau" then
				continue
			end
		end
		fs.copy(path(package.absolutePath, file), path(destinationDir, file))
	end
end

local function generateLinkerFile(package: types.Package, requirePath: string)
	local linkerSource = { `local DEPENDENCY = require("{requirePath}")` }

	local packageTypes = package.config.types
	if packageTypes then
		for type, value in packageTypes do
			table.insert(linkerSource, `export type {type} = DEPENDENCY.{if value == true then type else value}`)
		end
	end

	table.insert(linkerSource, "return DEPENDENCY\n")

	return table.concat(linkerSource, "\n")
end

local function packageLicensePath(package: types.Package)
	return if package.config.license then path(package.absolutePath, "LICENSE.md") else path(process.cwd, "LICENSE.md")
end

-- Pesde

local packageForPesde
do
	type PesdeEnvironment = "roblox" | "roblox_server" | "luau" | "lune"

	type PesdeTarget = {
		environment: PesdeEnvironment,
		lib: string,
		build_files: { string },
	}

	type PesdeIndices = {
		default: string,
	}

	type PesdeDependency = {
		name: string,
		version: string,
		index: string?,
		target: PesdeEnvironment?,
	}

	type PesdeManifest = {
		name: string,
		version: string,
		description: string,
		license: string,
		authors: { string },
		repository: string,

		indices: {
			default: string,
		},

		includes: { string },

		target: PesdeTarget,

		dependencies: { [string]: PesdeDependency }?,
	}

	local DEFAULT_TARGETS: { [PesdeEnvironment]: true } = {
		roblox = true,
		luau = true,
		lune = true,
	}

	local SYBAU_PESDE = '\
		[scripts]\
		roblox_sync_config_generator = ".pesde/scripts/roblox_sync_config_generator.luau"\
		sourcemap_generator = ".pesde/scripts/sourcemap_generator.luau"\
		\
		[dev_dependencies]\
		scripts = { name = "pesde/scripts_rojo", version = "^0.1.0", target = "lune" }\
		rojo = { name = "pesde/rojo", version = "^7.4.4", target = "lune" }\
	'

	local function pesdeify(name: string)
		return (string.gsub(name, "%-", "_"))
	end

	function packageForPesde(package: types.Package)
		local targets: { [PesdeEnvironment]: true } = package.config.pesdeTargets or DEFAULT_TARGETS

		local baseManifest: PesdeManifest = {
			name = pesdeify(`{rootConfig.publishers.pesde.scope}/{package.config.name}`),
			version = package.config.version or rootConfig.defaults.version,
			description = package.config.description,
			license = package.config.license or rootConfig.defaults.license,
			authors = package.config.authors or rootConfig.defaults.authors,
			repository = rootConfig.repository,

			indices = {
				default = rootConfig.publishers.pesde.registry,
			},

			includes = {
				"src/**/*.luau",
				"LICENSE.md",
				"README.md",
				"pesde.toml",
			},

			target = {
				environment = nil :: any,
				lib = "src/init.luau",
				build_files = {
					"src",
				},
			},
		}

		-- NOTE: serde is ass, we serializing this by hand
		local dependencies = { "[dependencies]" }
		local linkerFiles: { [string]: string } = {}
		if package.config.dependencies then
			for dependency in package.config.dependencies do
				local dependentPackage = nameToPackage[dependency]

				-- I love stylua
				table.insert(
					dependencies,
					`{dependency} = \{ name = "{pesdeify(
						`{rootConfig.publishers.pesde.scope}/{dependentPackage.config.name}`
					)}", `
						.. `version = "{dependentPackage.config.version or rootConfig.defaults.version}" }`
				)

				linkerFiles[dependency] = generateLinkerFile(dependentPackage, `./$TARGET_PACKAGES/{dependency}`)
			end
		end

		local dependenciesFooter = table.concat(dependencies, "\n")

		local licenseToCopy = packageLicensePath(package)

		for subtarget in targets do
			local distPackagePath = path(distPesdePath, subtarget, package.config.name)
			fs.writeDir(distPackagePath)

			local src = path(distPackagePath, "src")
			fs.writeDir(src)
			copyPackageDir(package, src)

			baseManifest = table.clone(baseManifest)
			baseManifest.target.environment = subtarget :: any

			for fileName, source in linkerFiles do
				local linkerFile = `{fileName}.luau`
				table.insert(baseManifest.includes, linkerFile)
				table.insert(baseManifest.target.build_files, linkerFile)
				fs.writeFile(
					path(distPackagePath, linkerFile),
					(string.gsub(source, "$TARGET_PACKAGES", `{subtarget}_packages`))
				)
			end

			local manifest = serde.encode("toml", baseManifest, true)
			manifest ..= dependenciesFooter
			manifest ..= "\n"

			if subtarget == "roblox" then
				-- why is pesde so overcomplicated
				manifest ..= SYBAU_PESDE
				fs.copy(path(process.cwd, ".lune", "pesde-scripts"), path(distPackagePath, ".pesde", "scripts"))
			end

			fs.writeFile(path(distPackagePath, "pesde.toml"), manifest)

			fs.copy(licenseToCopy, path(distPackagePath, "LICENSE.md"))
		end
	end
end

-- Wally

local packageForWally
do
	type WallyManifest = {
		package: {
			name: string,
			description: string,
			version: string,
			license: string,
			authors: { string },
			realm: "shared" | "server",
			registry: string,
			homepage: string,
			repository: string,
			private: boolean,
			dependencies: { [string]: string },
		},
	}

	function packageForWally(package: types.Package)
		local distPackagePath = path(distWallyPath, package.config.name)
		fs.writeDir(distPackagePath)

		local manifest: WallyManifest = {
			package = {
				name = `{rootConfig.publishers.wally.scope}/{package.config.name}`,
				description = package.config.description,
				version = package.config.version or rootConfig.defaults.version,
				license = package.config.license or rootConfig.defaults.license,
				authors = package.config.authors or rootConfig.defaults.authors,
				realm = "shared",
				registry = rootConfig.publishers.wally.registry,
				homepage = rootConfig.homepage,
				repository = rootConfig.repository,
				private = false,
				dependencies = {},
			},
		}

		if package.config.dependencies then
			for dependency in package.config.dependencies do
				local dependentPackage = nameToPackage[dependency]

				-- I love stylua
				manifest.package.dependencies[dependency] =
					`{rootConfig.publishers.wally.scope}/{dependentPackage.config.name}@{dependentPackage.config.version or rootConfig.defaults.version}`

				fs.writeFile(
					path(distPackagePath, `{dependency}.luau`),
					generateLinkerFile(dependentPackage, `./Packages/{dependency}`)
				)
			end
		end

		local src = path(distPackagePath, "src")
		fs.writeDir(src)
		copyPackageDir(package, src)

		fs.copy(packageLicensePath(package), path(distPackagePath, "LICENSE.md"))
		fs.writeFile(path(distPackagePath, "Wally.toml"), serde.encode("toml", manifest, true))
	end
end

-- NPM

local packageForNpm
do
	type NpmManifest = {
		name: string,
		version: string,
		description: string,
		main: string,
		types: string,
		files: { string },
		author: string,
		repository: {
			type: "git",
			url: string,
		},
		bugs: {
			url: string,
		},
		dependencies: { [string]: string },
	}

	local function copyPackageDir(package: types.Package, destinationDir: string)
		for _, file in fs.readDir(package.absolutePath) do
			if file:match("%.luau$") and file ~= "prvd.config.luau" then
				fs.copy(path(package.absolutePath, file), path(destinationDir, file))
			elseif file:match("%.ts$") then
				-- fixing import paths
				local contents = fs.readFile(path(package.absolutePath, file))
				contents = string.gsub(contents, 'from "%.%./%w+"', function(importPath)
					return string.gsub(importPath, "%.%./", `@{rootConfig.publishers.npm.scope}/`)
				end)
				fs.writeFile(path(destinationDir, file), contents)
			end
		end
	end

	function packageForNpm(package: types.Package)
		local distPackagePath = path(distNpmPath, package.config.name)
		fs.writeDir(distPackagePath)

		local manifest: NpmManifest = {
			name = `@{rootConfig.publishers.npm.scope}/{package.config.name}`,
			version = package.config.version or rootConfig.defaults.version,
			description = package.config.description,
			main = "src/init.luau",
			types = "src/init.luau",
			files = {
				"src",
				"LICENSE.md",
				"package.json",
			},
			author = (package.config.authors or rootConfig.defaults.authors)[1],
			repository = {
				type = "git",
				url = `git+{rootConfig.repository}.git`,
			},
			bugs = {
				url = `{rootConfig.repository}/issues`,
			},
			dependencies = {},
		}

		if package.config.dependencies then
			for dependency in package.config.dependencies do
				local dependentPackage = nameToPackage[dependency]

				-- I love stylua
				manifest.dependencies[`@{rootConfig.publishers.npm.scope}/{dependentPackage.config.name}`] = dependentPackage.config.version
					or rootConfig.defaults.version

				fs.writeFile(
					path(distPackagePath, `{dependency}.luau`),
					generateLinkerFile(dependentPackage, `./Packages/{dependency}`)
				)
			end
		end

		local src = path(distPackagePath, "src")
		fs.writeDir(src)
		copyPackageDir(package, src)

		fs.copy(packageLicensePath(package), path(distPackagePath, "LICENSE.md"))
		fs.writeFile(path(distPackagePath, "package.json"), serde.encode("json", manifest, true))
	end
end

local models: { [types.Package]: string } = {}

local function buildModel(package: types.Package)
	local distTempModelPath = path(distTempPath, "models", package.config.name)
	fs.writeDir(distTempModelPath)
	local src = path(distTempModelPath, "src")
	fs.writeDir(src)
	copyPackageDir(package, src)
	fs.writeFile(
		path(distTempModelPath, "default.project.json"),
		serde.encode("json", {
			name = package.config.name,
			tree = {
				["$path"] = "src",
			},
		}, true)
	)
	local result = process.exec("rojo", { "build", "-o", "model.rbxm", "default.project.json" }, {
		cwd = distTempModelPath,
	})
	assert(result.ok, result.stderr)
	local modelPath = path(distModelPath, `{package.config.name}.rbxm`)
	fs.move(path(distTempModelPath, "model.rbxm"), modelPath)
	models[package] = modelPath
	fs.removeDir(distTempModelPath)
end

for _, name in toBuild do
	print("Building package", name)
	local package = nameToPackage[name]

	packageForPesde(package)
	packageForWally(package)
	packageForNpm(package)

	buildModel(package)
end

fs.removeDir(distTempPath)
print("Building bundle")

local bundle = roblox.Instance.new("Folder")
bundle.Name = "prvdmwrong"

for _, modelPath in models do
	for _, instance in roblox.deserializeModel(fs.readFile(modelPath)) do
		instance.Parent = bundle
	end
end

fs.writeFile(distBundlePath, roblox.serializeModel({ bundle }))

local game = roblox.Instance.new("DataModel")
bundle.Parent = game:GetService("ReplicatedStorage")

fs.writeFile(distBundlePlacePath, roblox.serializePlace(game))
