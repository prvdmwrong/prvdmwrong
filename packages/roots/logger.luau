local logger = require("../logger")

return logger.createLogger("@prvdmwrong/roots", logger.standardErrorInfoUrl("roots"), {
	useAfterDestroy = "Cannot use Root after it is destroyed.",
	alreadyDestroyed = "Cannot destroy an already destroyed Root.",
})
