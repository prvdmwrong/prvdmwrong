local fs = require("@lune/fs")
local repoConfig = require("./repo-config")
local styles = require("@lune-utils/styles")
local types = require("./types")

local dim = styles.dim
local bold = styles.bold
local yellow = styles.yellow
local green = styles.green
local cyan = styles.cyan

local function collectPackages(packagesDir: string): { [string]: types.Package }
	local packages = {}
	local count = 0

	for _, package in fs.readDir(packagesDir) do
		local path = `{packagesDir}/{package}/`

		print(dim("Collecting"), bold(package), dim(`({path})`))
		if fs.isDir(path) then
			-- HACK: luau require doesnt support absolute pathsyet
			-- FIXME: pcall require doesn't work wtflocal result
			local config: types.PackageConfig
			local requireSuccess, requireError = pcall(function()
				config = (require)(`@compile/../{repoConfig.packageDir}/{package}/prvd.config`)
			end)
			if requireSuccess then
				print(styles.clearLine())
				print(green("Collected"), bold(package), dim(`({path})`))
				count += 1
				packages[package] = {
					path = path,
					config = config,
				}
			else
				local error = tostring(requireError)
				if string.find(error, "No file exists at the path") then
					print(yellow(`No prvd.config.luau for package "{package}"`))
				else
					print(yellow(`Failed to require prvd.config.luau for package "{package}"`))
				end
			end
		end
	end

	print(bold(cyan(`Finished collecting {count} packages`)))
	return packages
end

return collectPackages
