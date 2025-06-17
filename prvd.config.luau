local types = require("@compile/types")

return types.RepoConfig({
	repository = "https://github.com/prvdmwrong/prvdmwrong",
	packageDir = "packages",
	defaults = {
		authors = { "Fire <znotfireman@gmail.com>" },
		license = "MIT OR Apache-2.0",
	},
	publishers = {
		pesde = types.RepoPublisher({ scope = "prvdmwrong" }),
		wally = types.RepoPublisher({ scope = "prvdmwrong" }),
		npm = types.RepoPublisher({ scope = "prvdmwrong" }),
	},
})
