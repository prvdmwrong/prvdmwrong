local collectPackages = require("@self/collect-packages")
local fs = require("@lune/fs")
local printDivider = require("@lune-utils/print-divider")
local process = require("@lune/process")
local repoConfig = require("@self/repo-config")
local styles = require("@lune-utils/styles")
local types = require("@self/types")

type Package = {
	path: string,
	config: types.PackageConfig,
}

local green = styles.green

local compilers: { types.Compiler | types.Publisher } = {
	require("@self/compilers/rbxms"),
	require("@self/compilers/npm"),
	require("@self/compilers/pesde"),
	require("@self/compilers/wally"),
}

local function compile(rootDir: string)
	local distDir = `{rootDir}/dist`
	local packagesDir = `{rootDir}/{repoConfig.packageDir}`

	if fs.isDir(distDir) then
		fs.removeDir(distDir)
	end

	fs.writeDir(distDir)

	printDivider(`Collecting packages (from /{repoConfig.packageDir})`)
	local packages = collectPackages(packagesDir)

	local ctx: types.CompilerContext = {
		rootDir = rootDir,
		distDir = distDir,
		packagesDir = packagesDir,
		packages = packages,
	}

	printDivider("Compiling")
	for _, compiler in compilers :: { types.Compiler } do
		if compiler.implements.Compiler then
			print(green("Compiling"), compiler.label)
			compiler:compile(ctx)
		end
	end
end

compile((string.gsub(process.cwd, "/$", "")))
