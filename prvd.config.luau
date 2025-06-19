local configure = require("@lune-lib/configure")

return configure.repo({
	repository = "https://github.com/prvdmwrong/prvdmwrong",
	packageDir = "packages",
	defaults = {
		authors = { "Fire <znotfireman@gmail.com>" },
		license = "MIT OR Apache-2.0",
	},
	publishers = {
		pesde = configure.publisher({ scope = "prvdmwrong" }),
		wally = configure.publisher({ scope = "prvdmwrong" }),
		npm = configure.publisher({ scope = "prvdmwrong" }),
	},
})
