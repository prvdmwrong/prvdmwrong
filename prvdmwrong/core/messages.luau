local messages = table.freeze {
	alreadyStarted = "This root has already been `start()`ed.",
	alreadyStopped = "This root has already been `stop()`ed.",
	cannotCreateProvider = "Cannot create the provider - %s.",
	destroyedTwice = "Cannot destroy %s more than twice.",
	onInitError = "Cannot initialize root provider %s - %s.",
	requireError = "Cannot require module %s - %s.",
	unknownError = "Unknown error: %s. This indicates Prvd 'M Wrong isn't reporting errors correctly, please file an issue.",
	useAfterDestroy = "Cannot use %s after it's destroyed.",
	useWasDeprecated = "`prvd.use(callback)` was deprecated, specify the provider directly instead.",
}

export type Message = keyof<typeof(messages)>

return messages :: { [Message]: string }
