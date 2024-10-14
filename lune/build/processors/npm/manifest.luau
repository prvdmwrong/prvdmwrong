local any: any = nil

return {
  name = any :: string,
  description = any :: string,
  version = any :: string,
  dependencies = any :: { [string]: string },
  main = "src/init.luau",
  author = "znotfireman <znotfireman+hello@gmail.com>",
  license = "MIT OR Apache-2.0",
  types = "src/index.d.ts",
  files = {
    "src",
    "!**/*.tsbuildinfo",
  },
  publishConfig = {
    access = "public",
  },
  devDependencies = {
    ["@rbxts/compiler-types"] = "2.3.0-types.1",
    ["@rbxts/types"] = "^1.0.790",
    ["roblox-ts"] = "^2.3.0",
    typescript = "^5.5.4",
  },
}
