export type PackageConfig = {
	name: string,
	description: string,
}

local function PackageConfig(x: PackageConfig)
	return table.freeze(x)
end

return table.freeze({
	PackageConfig = PackageConfig,
})
