local logger = require("../logger")

return logger.createLogger("@prvdmwrong/dependencies", logger.standardErrorInfoUrl("dependencies"), {
	useBeforeConstructed = "Cannot use %s before it is constructed. Are you using the dependency outside a class method?",
	alreadyDestroyed = "Cannot destroy an already destroyed Root.",
	alreadyFinished = "Root has already finished.",
})
