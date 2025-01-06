local ProgressBar = require("./utils/progress")
local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")
local t = require("./utils/t")

export type PackageConfiguration = {
	name: string,
	description: string,
	version: string,
	dependencies: string,
	types: { string },
}

export type Package = {
	name: string,
	relativePath: string,
	cwdPath: string,
	configuration: PackageConfiguration,
}

export type PublishTarget = {
	scope: string,
}

export type RepoConfiguration = {
	publish: {
		authors: { string },
		repository: string,
		license: string,

		target: {
			pesde: PublishTarget,
			npm: PublishTarget,
			wally: PublishTarget,
		},
	},
}

local PackageConfiguration = t.interface {
	name = t.string,
	description = t.string,
	version = t.string,
	dependencies = t.string,
	types = t.array(t.string),
}

local PublishTarget = t.interface {
	scope = t.string,
}

local RepoConfiguration = t.interface {
	publish = t.interface {
		authors = t.array(t.string),
		repository = t.string,
		license = t.string,

		target = t.interface {
			pesde = PublishTarget,
			npm = PublishTarget,
			wally = PublishTarget,
		},
	},
}

local CWD = process.cwd
local PATH_DELIMITER = if process.os == "windows" then "\\" else "/"

local packageConfigurations: { [string]: PackageConfiguration } = {}
local allPackages: { string }? = nil
local packages: { [string]: Package } = {}
local repoConfiguration: RepoConfiguration? = nil

local function implementPath<T...>(fn: (path: string) -> T...): (...string) -> T...
	return function(...)
		return fn(table.concat({ ... }, PATH_DELIMITER))
	end
end

local function implementCwdPath<T...>(fn: (path: string) -> T...): (...string) -> T...
	return function(...)
		return fn(table.concat({ CWD, ... }, PATH_DELIMITER))
	end
end

--[=[
    Commonly used functions across all Lune scripts
]=]
local prelude = {
	ProgressBar = ProgressBar.new,
	t = t,

	readFile = implementPath(fs.readFile),
	readDir = implementPath(fs.readDir),
	removeFile = implementPath(fs.removeFile),
	removeDir = implementPath(fs.removeDir),
	isFile = implementPath(fs.isFile),
	isDir = implementPath(fs.isDir),
	writeFile = fs.writeFile,
	writeDir = implementPath(fs.writeDir),

	readCwdFile = implementCwdPath(fs.readFile),
	readCwdDir = implementCwdPath(fs.readDir),
	removeCwdFile = implementCwdPath(fs.removeFile),
	removeCwdDir = implementCwdPath(fs.removeDir),
	isCwdFile = implementCwdPath(fs.isFile),
	isCwdDir = implementCwdPath(fs.isDir),
	writeCwdDir = implementCwdPath(fs.writeDir),
}

function prelude.path(...: string)
	return table.concat({ ... }, PATH_DELIMITER)
end

function prelude.cwdPath(...: string)
	return table.concat({ CWD, ... }, PATH_DELIMITER)
end

prelude.RELATIVE_PACKAGES_PATH = prelude.path("prvdmwrong")
prelude.CWD_PACKAGES_PATH = prelude.cwdPath(prelude.RELATIVE_PACKAGES_PATH)

function prelude.writeFileAs(format: serde.EncodeDecodeFormat, path: string, contents: any)
	return prelude.writeFile(path, serde.encode(format, contents))
end

function prelude.parseFile(format: serde.EncodeDecodeFormat, ...: string)
	return serde.decode(format, prelude.readFile(...))
end

function prelude.parseCwdFile(format: serde.EncodeDecodeFormat, ...: string)
	return serde.decode(format, prelude.readCwdFile(...))
end

function prelude.repoConfiguration(): RepoConfiguration
	if repoConfiguration then
		return repoConfiguration
	end

	local config = prelude.parseCwdFile("toml", "prvd.toml")
	assert(RepoConfiguration(config))

	repoConfiguration = config
	return config :: any
end

function prelude.packageConfiguration(package: string): PackageConfiguration
	local preexisting = packageConfigurations[package]
	if packageConfigurations[package] then
		return preexisting
	end

	print(prelude.path(prelude.CWD_PACKAGES_PATH, package))
	assert(prelude.isFile(prelude.CWD_PACKAGES_PATH, package), `{package} doesnt exist`)

	local config = prelude.parseFile("toml", prelude.CWD_PACKAGES_PATH, package, "prvd.toml")
	assert(PackageConfiguration(config))

	packageConfigurations[package] = config
	return config :: any
end

function prelude.allPackages(): { string }
	if allPackages then
		return allPackages
	end

	local children = prelude.readDir(prelude.CWD_PACKAGES_PATH)
	allPackages = {}

	for _, child in children do
		if
			prelude.isDir(prelude.CWD_PACKAGES_PATH, child)
			and prelude.isFile(prelude.CWD_PACKAGES_PATH, child, "prvd.toml")
		then
			table.insert(allPackages, child)
		end
	end

	return allPackages
end

function prelude.package(package: string): Package
	local preexisting = packages[package]
	if preexisting then
		return preexisting
	end

	local relativePath = prelude.path(prelude.RELATIVE_PACKAGES_PATH, package)
	local cwdPath = prelude.cwdPath(relativePath)
	assert(prelude.isDir(cwdPath), `{relativePath} doesnt exist`)

	local self: Package = {
		name = package,
		relativePath = relativePath :: string,
		cwdPath = cwdPath :: string,
		configuration = prelude.packageConfiguration(package),
	}

	packages[package] = self
	return self
end

return prelude
