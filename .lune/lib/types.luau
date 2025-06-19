local configure = require("@lune-lib/configure")

export type PackageContext = {
	rootDir: string,
	outDir: string,
	outWorkDir: string,
	packagesDir: string,
	packages: { [string]: Package },
}

export type Package = {
	path: string,
	config: configure.PackageConfig,
}

return nil
