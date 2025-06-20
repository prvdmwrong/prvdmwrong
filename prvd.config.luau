local configure = require("@lune-lib/configure")

return configure.root({
	repository = "https://github.com/prvdmwrong/prvdmwrong",
	homepage = "https://prvdmwrong.luau.page/latest/",
	packageDir = "packages",
	defaults = {
		authors = { "Fire <znotfireman@gmail.com>" },
		license = "MPL-2.0",
		version = "0.2.0-rc.1",
	},
	publishers = {
		pesde = configure.publisher({ scope = "prvdmwrong", registry = "https://github.com/pesde-pkg/index" }),
		wally = configure.publisher({ scope = "prvdmwrong", registry = "https://github.com/upliftgames/wally-index" }),
		npm = configure.publisher({ scope = "prvdmwrong", registry = "" }),
	},
})
