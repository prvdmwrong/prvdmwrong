local logger = require("../logger")

return logger.Logger("@prvdmwrong/lifecycles", {
	useAfterDestroy = "Cannot use Lifecycle after it is destroyed.",
	alreadyDestroyed = "Cannot destroy an already destroyed Lifecycle.",
})
