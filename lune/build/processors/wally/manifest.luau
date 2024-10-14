local any: any = nil

return {
  package = {
    name = any :: string,
    description = any :: string,
    version = any :: string,
    dependencies = {} :: { [string]: string },
    license = "MIT OR Apache-2.0",
    authors = { "znotfireman <znotfireman+hello@gmail.com>" },

    realm = "shared",
    repository = "https://github.com/prvdmwrong/prvdmwrong",
    registry = "https://github.com/UpliftGames/wally-index",

    include = {
      "./src",
      "./default.project.json",
    },

    exclude = {
      "node_modules",
    },
  },
}
