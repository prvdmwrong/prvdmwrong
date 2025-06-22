-- Repository

export type RootPublisher = {
	scope: string,
	registry: string,
}

local function publisher(x: RootPublisher)
	return table.freeze(x)
end

export type RepoConfig = {
	repository: string,
	homepage: string,
	packageDir: string,
	defaults: {
		authors: { string },
		license: string,
		version: string,
	},
	publishers: {
		pesde: RootPublisher,
		wally: RootPublisher,
		npm: RootPublisher,
	},
}

local function root(x: RepoConfig)
	return table.freeze(x)
end

-- Packages

export type PackageName =
	| "prvdmwrong"
	| "runtime"
	| "logger"
	| "dependencies"
	| "providers"
	| "lifecycles"
	| "roots"
	| "rbx-components"
	| "rbx-lifecycles"

export type PackageTarget = "roblox"

export type PackageDependencies = { [PackageName]: true? }

local function dependencies(x: PackageDependencies)
	return table.freeze(x)
end

export type PackageConfig = {
	name: string,
	description: string,

	authors: { string }?,
	license: string?,
	version: string?,

	pesdeTargets: { [PesdeEnvironment]: true }?,

	dependencies: PackageDependencies?,

	types: { [string]: boolean | string }?,
}

local function package(x: PackageConfig)
	return table.freeze(x)
end

export type PesdeEnvironment = "roblox" | "roblox_server" | "luau" | "lune"

return table.freeze({
	root = root,
	publisher = publisher,
	package = package,
	dependencies = dependencies,
})
