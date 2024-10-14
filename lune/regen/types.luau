local t = require("../tiny")

local types = {}

export type Config = index<RawConfig, "config">
export type RawConfig = {
  config: {
    name: string,
    module: string,
    description: {
      brief: string,
      technical: string,
    },
    docs: {
      classes: { string },
    },
  },
}

types.RawConfig = t.interface {
  config = t.interface {
    name = t.string,
    module = t.string,
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
  loadOrder: number?,
  generate: (self: Generator, packages: { PackageData }) -> (),
}

types.Generator = t.interface {
  type = t.literal("Generator"),
  of = t.string,
  loadOrder = t.optional(t.number),
  generate = t.callback,
}

return types
