-- Repository

export type RepoPublisher = {
	scope: string,
}

local function publisher(x: RepoPublisher)
	return table.freeze(x)
end

export type RepoConfig = {
	repository: string,
	packageDir: string,
	defaults: {
		authors: { string },
		license: string,
	},
	publishers: {
		pesde: RepoPublisher,
		wally: RepoPublisher,
		npm: RepoPublisher,
	},
}

local function repo(x: RepoConfig)
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
	pesdeTargets: { [PesdeEnvironment]: true }?,

	dependencies: PackageDependencies?,

	types: { [string]: any }?,
}

local function package(x: PackageConfig)
	return table.freeze(x)
end

-- Publishers

-- we support all targets :trol:
export type PesdeEnvironment = "roblox" | "roblox_server" | "luau" | "lune"

export type PesdeTarget = {
	environment: PesdeEnvironment,
	lib: string,
	build_files: { string },
}

export type PesdeIndices = {
	default: string,
}

export type PesdeDependency = {
	name: string,
	version: string,
	index: string?,
	target: PesdeEnvironment?,
}

export type PesdeManifest = {
	name: string,
	version: string,
	description: string,
	license: string,
	authors: { string },
	repository: string,

	includes: { string },

	target: PesdeTarget,

	dependencies: { [string]: PesdeDependency }?,
}

return table.freeze({
	repo = repo,
	publisher = publisher,
	package = package,
	dependencies = dependencies,
})
