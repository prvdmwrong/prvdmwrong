export type PackageConfig = {
	name: string,
	description: string,

	dependencies: {
		[string]: true,
	}?,

	types: {
		[string]: true,
	}?,
}

local function PackageConfig(x: PackageConfig)
	return table.freeze(x)
end

return table.freeze({
	PackageConfig = PackageConfig,
})
