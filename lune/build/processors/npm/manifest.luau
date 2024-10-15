local any: any = nil

return {
  name = any :: string,
  description = any :: string,
  version = any :: string,
  dependencies = any :: { [string]: string },
  main = "src/init.luau",
  author = any :: string,
  license = any :: string,
  types = "src/index.d.ts",
  files = {
    "src",
    "!**/*.tsbuildinfo",
  },
  publishConfig = {
    access = "public",
  },
  repository = {
    type = "git",
    url = any :: string,
  },
  devDependencies = {
    ["@rbxts/compiler-types"] = "2.3.0-types.1",
    ["@rbxts/types"] = "^1.0.790",
    ["roblox-ts"] = "^2.3.0",
    typescript = "^5.5.4",
  },
}
