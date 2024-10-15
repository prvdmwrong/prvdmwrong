local any: any = nil

return {
  name = any :: string,
  version = any :: string,
  description = any :: string,
  authors = any :: { string },
  repository = any :: string,
  license = any :: string,

  includes = {
    "src",
    "README.md",
    "LICENSE",
    "pesde.toml",
    "default.project.json",
  },

  indices = {
    default = "https://github.com/daimond113/pesde-index",
  },

  target = {
    environment = "roblox",
    lib = "src/init.luau",
  },

  dependencies = any :: { [string]: { name: string, version: string } },
}
