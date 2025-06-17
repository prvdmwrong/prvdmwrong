export type PackageName = "core" | "components" | "logger" | "lifecycles" | "rbx-lifecycles" | "runtime"

export type PackageDependencies = { [PackageName]: true? }

local function PackageDependencies(x: PackageDependencies)
	return table.freeze(x)
end

export type PackageConfig = {
	name: string,
	description: string,

	dependencies: PackageDependencies?,

	types: { [string]: any }?,
}

local function PackageConfig(x: PackageConfig)
	return table.freeze(x)
end

return table.freeze({
	PackageDependencies = PackageDependencies,
	PackageConfig = PackageConfig,
})
