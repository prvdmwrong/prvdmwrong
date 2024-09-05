--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local assertion = require("../utils/assertion")
local color = require("../utils/color")
local config = require("../utils/config")
local fs = require("@lune/fs")
local path = require("../utils/path")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local summon = require("../utils/summon")

local templates = require("./templates")

local CWD = process.cwd
local DIST_DIRECTORY = path(CWD, "dist")
local SCOPE = "prvdmwrong"
local WILL_PUBLISH = true

local DARKLUA_DIST = path(CWD, ".lune", "build", "darklua.dist.json")
local DARKLUA_DEV = path(CWD, ".lune", "build", "darklua.dev.json")

local function createCycle<T>(functions: { T }): () -> T
	local index = 1
	local currentFunction = functions[index]

	local function cycle()
		index += 1
		if index > #functions then
			index = 1
		end
		currentFunction = functions[index]
		return currentFunction
	end

	return cycle
end

local function build(props: {
	packages: { string },
	shouldCreateRbxms: boolean,
	shouldRelease: boolean,
	version: string,
})
	-- stylua: ignore
	local packages, shouldCreateRbxms, shouldRelease, version = props.packages, props.shouldCreateRbxms, props.shouldRelease, props.version
	assertion(version:match("^(%d+)%.?(%d*)%.?(%d*)(.-)$") ~= nil, `{version} is not a valid semver version`)

	local target = shouldRelease and version or "development"
	print(color.yellow("[Prvd 'M Wrong]"), "Building", table.concat(packages, ", "), "for", target)

	if fs.isDir(DIST_DIRECTORY) then
		print(color.yellow("[Prvd 'M Wrong]"), "Deleting dist folder")
		assertion(pcall(fs.removeDir, DIST_DIRECTORY))
	end

	print(color.yellow("[Prvd 'M Wrong]"), "Generating bundle sourcemap")
	summon("rojo", "sourcemap", path(CWD, "default.project.json"), "-o", path(CWD, "sourcemap.json"))

	local bundle = roblox.Instance.new("Model")
	bundle.Name = "prvdmwrong-bundle"

	local darkluaConfig = shouldRelease and DARKLUA_DIST or DARKLUA_DEV
	fs.writeDir(DIST_DIRECTORY)

	local cycleColor = createCycle { color.blue, color.red, color.purple }
	for _, package in props.packages do
		local colorString = cycleColor()

		if fs.isDir(path(CWD, "dist", package)) then
			continue
		end

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Processing", `@{SCOPE}/{package}`)
		fs.writeDir(path(CWD, "dist", package))
		-- stylua: ignore
		summon(
			"darklua",
			"process",
			shouldRelease and path(CWD, "packages", package, "lib", "init.luau") or path(CWD, "packages", package, "lib"),
			shouldRelease and path(DIST_DIRECTORY, package, "lib", "init.lua") or path(DIST_DIRECTORY, package, "lib"),
			"-c",
			darkluaConfig,
			"-v"
		)

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Writing default.project.json")
		local projectFile = table.clone(templates.project)
		projectFile.name = `{SCOPE}-{package}`
		fs.writeFile(path(DIST_DIRECTORY, package, "default.project.json"), serde.encode("json", projectFile))

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Writing version for init.luau exports")
		local init = path(DIST_DIRECTORY, package, "lib", shouldRelease and "init.lua" or "init.luau")
		fs.writeFile(path(init), (fs.readFile(init):gsub("VERSION", version or "0.0.0-dev")))

		if shouldCreateRbxms then
			print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Building .rbxm model")
			local rbxmName = `prvdmwrong-{package}`
			local rbxmPath = path(DIST_DIRECTORY, rbxmName) .. ".rbxm"
			summon("rojo", "build", path(DIST_DIRECTORY, package, "default.project.json"), "-o", rbxmPath)

			print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Adding to bundled .rbxm")
			local instances = roblox.deserializeModel(fs.readFile(rbxmPath))
			for _, instance in instances do
				instance.Parent = bundle
			end
		end

		if not shouldRelease then
			continue
		end

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Minifying")
		-- Fym when i have to specify column span twice
		summon(
			"darklua",
			"minify",
			path(DIST_DIRECTORY, package, "lib"),
			path(DIST_DIRECTORY, package, "lib"),
			"--column-span",
			"9999999999"
		)

		-- stylua: ignore
		local packageConfig = config.intoConfig(serde.decode("toml", fs.readFile(path(CWD, "packages", package, "config.toml"))))
		local packageName = `{SCOPE}/{packageConfig.config.name}`

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Preparing wally.toml")
		local wally = table.clone(templates.wally)
		wally.package.name = packageName
		wally.package.description = packageConfig.config.description
		wally.package.version = version

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Preparing package.json")
		local npm = table.clone(templates.npm)
		npm.name = `@{packageName}`
		npm.description = packageConfig.config.description
		npm.version = version

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Preparing pesde.yaml")
		local pesde = table.clone(templates.pesde)
		pesde.name = packageName:gsub("-", "_")
		pesde.description = packageConfig.config.description
		pesde.version = version

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Preparing dependencies")
		local dependencies = packageConfig.config.dependencies
		if dependencies then
			local wallyDependencies = {}
			local npmDependencies = {}
			local pesdeDependencies = {}

			for _, dependency in ipairs(dependencies) do
				print(`  => Writing dependency {dependency}`)
				wallyDependencies[dependency] = `{SCOPE}/{dependency}@{version}`
				npmDependencies[`@{SCOPE}/{dependency}`] = version
				pesdeDependencies[dependency] = {
					name = (`{SCOPE}/{dependency}`):gsub("-", "_"),
					version = version,
				}
			end

			wally.package.dependencies = wallyDependencies
			npm.dependencies = npmDependencies
			pesde.dependencies = pesdeDependencies
		end

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Writing wally.toml")
		fs.writeFile(path(CWD, "dist", package, "wally.toml"), serde.encode("toml", wally))

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Writing package.json")
		fs.writeFile(path(CWD, "dist", package, "package.json"), serde.encode("json", npm))

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Writing pesde.yaml")
		fs.writeFile(path(CWD, "dist", package, "pesde.yaml"), serde.encode("yaml", pesde))

		print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Copying license files")
		fs.copy(path(CWD, "LICENSE-MIT.md"), path(DIST_DIRECTORY, package, "LICENSE-MIT.md"))
		fs.copy(path(CWD, "LICENSE-APACHE.md"), path(DIST_DIRECTORY, package, "LICENSE-APACHE.md"))

		local packageReadme = path(CWD, "packages", package, "README.md")
		local distReadme = path(DIST_DIRECTORY, package, "README.md")
		if fs.isFile(packageReadme) then
			print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Writing existing README.md")
			fs.copy(packageReadme, distReadme)
		else
			print(colorString(`[Prvd 'M Wrong > @{SCOPE}/{package}]`), "Writing new README.md")
			local readme = `# {packageConfig.config.display}`
			readme ..= "\n\n"
			readme ..= packageConfig.config.description:gsub("\n[^\n]*$", "")
			readme ..= "\n\n"
			readme ..= `This package is a part of [Prvd 'M Wrong.](https://prvdmwrong.github.io/prvdmwrong/latest)`
			fs.writeFile(distReadme, readme)
		end
	end

	if shouldCreateRbxms then
		print(color.green("[Prvd 'M Wrong]"), "Serializing bundled .rbxm")
		fs.writeFile(path(DIST_DIRECTORY, "prvdmwrong-bundle.rbxm"), roblox.serializeModel { bundle })
	end

	if shouldRelease and WILL_PUBLISH then
		for _, package in packages do
			print(color.green(`[Prvd 'M Wrong > @prvdmwrong/{package}]`), "Publishing to wally")
			summon("wally", "publish", "-v", "--project-path", path(DIST_DIRECTORY, package))

			print(color.green(`[Prvd 'M Wrong > @prvdmwrong/{package}]`), "Publishing to NPM")
			process.spawn("npm", { "publish" }, {
				shell = true,
				cwd = path(DIST_DIRECTORY, package),
			})

			print(color.green(`[Prvd 'M Wrong > @prvdmwrong/{package}]`), "Publishing to pesde")
			process.spawn("pesde", { "publish" }, {
				shell = true,
				cwd = path(DIST_DIRECTORY, package),
			})
		end
	end

	print(color.green("[Prvd 'M Wrong]"), "Build finished 🎉")
end

return build
