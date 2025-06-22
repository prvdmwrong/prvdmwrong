local configure = require("@lune-lib/configure")
local fs = require("@lune/fs")
local path = require("@lune-lib/utils/path")
local types = require("@lune-lib/types")

local function collectPackages(rootPath: string, packageDir: string)
	local packages: { types.Package } = {}
	local packageDirPath = path(rootPath, packageDir)
	local knownNames = {}

	for _, package in fs.readDir(packageDirPath) do
		local packagePath = path(packageDirPath, package)
		if fs.isDir(packagePath) then
			local packageRelativePath = path(packageDir, package)
			local configRequirePath = path(packageRelativePath, "prvd.config")
			local configPath = path(packagePath, "prvd.config.luau")

			if fs.isFile(configPath) then
				-- HACK: lune i beg you to have a cwd parameter for requires
				local config: configure.PackageConfig = (require)(`@lune-lib/../../{configRequirePath}`)

				assert(not knownNames[config.name], `Duplicate package name found: {config.name}`)
				knownNames[config.name] = true

				table.insert(packages, {
					absolutePath = packagePath,
					relativePath = packageRelativePath,
					config = config,
				})
			end
		end
	end

	return packages
end

return collectPackages
