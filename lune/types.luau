local t = require("./tiny")

local types = {}

export type Config = {
  config: {
    name: string,
    module: string,
    description: string,
    dependencies: { string }?,
  },
  docs: {
    classes: { string },
    overview: string,
  },
}

types.Config = t.interface {
  config = t.interface {
    name = t.string,
    module = t.string,
    description = t.string,
    dependencies = t.optional(t.array(t.string) :: any),
  },
  docs = t.interface {
    classes = t.array(t.string),
    overview = t.string,
  },
}

export type Package = {
  name: string,
  absolutePath: string,
  relativePath: string,
  config: Config,
}

export type BuildProcessor = {
  process: (self: BuildProcessor, package: Package) -> (),
  publish: (self: BuildProcessor, package: Package) -> ()?,
}

return types
