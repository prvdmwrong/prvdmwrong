local t = require("../tiny")

local types = {}

export type Config = {
  config: {
    name: string,
    module: string,
    description: string,
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
  },
  docs = t.interface {
    classes = t.array(t.string),
    overview = t.string,
  },
}

export type RootConfig = {
  docs: {
    sort_order: { string },
  },
}

types.RootConfig = t.interface {
  docs = t.interface {
    sort_order = t.array(t.string),
  },
}

export type PackageData = {
  name: string,
  absolutePath: string,
  relativePath: string,
  config: Config,
}

return types
