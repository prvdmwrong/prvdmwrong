local t = require("../tiny")

local types = {}

export type Config = index<RawConfig, "config">
export type RawConfig = {
  config: {
    name: string,
    description: string,
  },
}

types.RawConfig = t.interface {
  config = t.interface {
    name = t.string,
    description = t.string,
  },
}

export type PackageData = {
  name: string,
  absolutePath: string,
  relativePath: string,
  config: Config,
}

export type Generator = {
  type: "Generator",
  of: string,
  generate: (self: Generator, packages: { PackageData }) -> (),
}

types.Generator = t.interface {
  type = t.literal("Generator"),
  of = t.string,
  generate = t.callback,
}

return types
