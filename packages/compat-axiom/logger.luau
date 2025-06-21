local logger = require("../logger")

return logger.create("@prvdmwrong/compat-axiom", logger.standardErrorInfoUrl("compat-axiom"), {
	migrateToLifecycles = "Please use the lifecycle API in Prvd 'M Wrong instead.",
	migrateToRootUseModules = "Please use root's useModules API in Prvd 'M Wrong instead.",
	migrateToRootStart = "Please use the root's start API in Prvd 'M Wrong instead.",
})
