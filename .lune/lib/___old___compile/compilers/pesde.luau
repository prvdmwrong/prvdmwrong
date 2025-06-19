local fs = require("@lune/fs")
local process = require("@lune/process")
local repoConfig = require("@compile/repo-config")
local serde = require("@lune/serde")
-- local styles = require("@lune-utils/styles")
local types = require("@compile/types")

local DEFAULT_TARGETS: { [types.PesdeEnvironment]: true } = {
	roblox = true,
	luau = true,
	lune = true,
}

local workspaceManifest = {
	name = "prvdmwrong/prvdmwrong_root",
	version = "0.0.0",
	private = true,

	workspace_members = {},

	target = {
		environment = nil :: string?,
	},
}

local function pesdeify(name: string)
	return string.gsub(name, "%-", "_")
end

local function packageNameOf(name: string)
	return pesdeify(`{repoConfig.publishers.pesde.scope}/{name}`)
end

local function writeWorkspaceManifest(rootManifestPath: string)
	fs.writeFile(rootManifestPath, serde.encode("toml", workspaceManifest, true))
end

local function cycleWorkspaceTargets(rootManifestPath: string, iterator: () -> ())
	for target in DEFAULT_TARGETS do
		workspaceManifest.workspace_members = { `dist/pesde/*/{target}` }
		workspaceManifest.target.environment = target

		writeWorkspaceManifest(rootManifestPath)

		iterator()
	end
end

local PesdeCompiler = {} :: types.Compiler & types.Publisher
PesdeCompiler.implements = { Compiler = true :: true, Publisher = true :: true }
PesdeCompiler.label = "pesde"

function PesdeCompiler:compile(ctx)
	local distPesdeDir = `{ctx.distDir}/pesde/`
	fs.writeDir(distPesdeDir)

	for _, package in ctx.packages do
		local distPackagePath = `{distPesdeDir}/{package.config.name}`

		fs.writeDir(distPackagePath)

		-- HACK: serde.encode does [dependencies.package] rahh

		local dependencies: { string } = {}
		if package.config.dependencies then
			table.insert(dependencies, "[dependencies]")
			for dependency in package.config.dependencies do
				table.insert(
					dependencies,
					`{dependency} = \{ workspace = "{packageNameOf(dependency)}", version = "^" \}`
				)
			end
		end

		local manifest: types.PesdeManifest = {
			name = packageNameOf(package.config.name),
			version = "0.2.0",
			description = package.config.description,
			license = package.config.license or repoConfig.defaults.license,
			authors = package.config.authors or repoConfig.defaults.authors,
			repository = repoConfig.repository,

			includes = {
				"**/*.luau",
				"**/!(prvd.config.luau)",
			},

			target = {
				environment = "luau",
				lib = "src/init.luau",
				build_files = {
					"src",
				},
			},
		}

		local packageTargets: { [types.PesdeEnvironment]: true } = package.config.pesdeTargets or DEFAULT_TARGETS

		for target in packageTargets do
			manifest.target.environment = target :: any

			local distTargetPath = `{distPackagePath}/{target}`
			fs.writeDir(distTargetPath)

			local distSrcPath = `{distTargetPath}/src`

			fs.copy(package.path, distSrcPath)
			fs.writeFile(
				`{distTargetPath}/pesde.toml`,
				serde.encode("toml", manifest, true) .. `\n{table.concat(dependencies, "\n")}`
			)

			if package.config.dependencies then
				for dependency in package.config.dependencies do
					local dependencyPackage = ctx.packages[dependency]
					assert(
						dependencyPackage,
						`Package "{package.config.name}" depends on invalid package "{dependency}"`
					)

					local linkerSource = { `local DEPENDENCY = require("./{target}_packages/{dependency}")` }

					local dependencyTypes = dependencyPackage.config.types
					if dependencyTypes then
						for type, value in dependencyTypes do
							table.insert(
								linkerSource,
								`export type {type} = DEPENDENCY.{if value == true then type else value}`
							)
						end
					end

					table.insert(linkerSource, "return DEPENDENCY\n")

					fs.writeFile(`{distTargetPath}/{dependency}.luau`, table.concat(linkerSource, "\n"))
				end
			end
		end
	end

	local rootManifestPath = `{ctx.rootDir}/pesde.toml`

	cycleWorkspaceTargets(rootManifestPath, function()
		process.exec("pesde", { "install" })
	end)

	workspaceManifest.workspace_members = { "dist/pesde/*/roblox", "test-runner" }
	workspaceManifest.target.environment = "roblox"
	writeWorkspaceManifest(rootManifestPath)
end

function PesdeCompiler:publish(ctx)
	cycleWorkspaceTargets(`{ctx.rootDir}/pesde.toml`, function()
		process.exec("pesde", { "publish" })
	end)
end

return PesdeCompiler
