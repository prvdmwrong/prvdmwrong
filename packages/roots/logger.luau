local logger = require("../logger")

return logger.create("@prvdmwrong/roots", logger.standardErrorInfoUrl("roots"), {
	useAfterDestroy = "Cannot use Root after it is destroyed.",
	alreadyDestroyed = "Cannot destroy an already destroyed Root.",
	alreadyFinished = "Root has already finished.",
})
