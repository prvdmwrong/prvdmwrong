-- Compiler

export type Compiler = {
	label: string,
	implements: { Compiler: true, [string]: true },
	compile: (self: Compiler, ctx: CompilerContext) -> (),
}

export type Publisher = {
	label: string,
	implements: { Publisher: true, [string]: true },
	publish: (self: Publisher, ctx: CompilerContext) -> (),
}

export type CompilerContext = {
	rootDir: string,
	distDir: string,
	packagesDir: string,
	packages: { [string]: Package },
}

export type Package = {
	path: string,
	config: PackageConfig,
}

-- Repository

export type RepoPublisher = {
	scope: string,
}

local function RepoPublisher(x: RepoPublisher)
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

local function RepoConfig(x: RepoConfig)
	return table.freeze(x)
end

-- Packages

export type PackageName =
	| "prvdmwrong"
	| "dependencies"
	| "providers"
	| "roots"
	| "components"
	| "logger"
	| "lifecycles"
	| "rbx-lifecycles"
	| "runtime"

export type PackageTarget = "roblox"

export type PackageDependencies = { [PackageName]: true? }

local function PackageDependencies(x: PackageDependencies)
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

local function PackageConfig(x: PackageConfig)
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
	RepoPublisher = RepoPublisher,
	RepoConfig = RepoConfig,
	PackageDependencies = PackageDependencies,
	PackageConfig = PackageConfig,
})
