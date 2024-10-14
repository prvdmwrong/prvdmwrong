local any: any = nil

return {
  name = any :: string,
  version = any :: string,
  description = any :: string,
  authors = { "znotfireman <znotfireman+hello@gmail.com>" },
  repository = "https://github.com/prvdmwrong/prvdmwrong",
  license = "MIT OR Apache-2.0",

  includes = {
    "./src",
    "./default.project.json",
  },

  indices = {
    default = "https://github.com/daimond113/pesde-index",
  },
}
