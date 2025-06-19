local logger = require("../logger")

return logger.create("@prvdmwrong/lifecycles", logger.standardErrorInfoUrl("lifecycles"), {
	useAfterDestroy = "Cannot use Lifecycle after it is destroyed.",
	alreadyDestroyed = "Cannot destroy an already destroyed Lifecycle.",
})
