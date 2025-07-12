local logger = require("../logger")

return logger.create("@prvdmwrong/rbx-components", logger.standardErrorInfoUrl("rbx-components"), {
	alreadyExtendedRoot = "Root already has component extension.",
	invalidComponent = "Not a component, create one with `components(MyComponent)` or `components.create(MyComponent)`.",
	alreadyRegisteredComponent = "Component already registered.",
	multipleSameTag = "Multiple components use the CollectionService tag '%s', which is likely a mistake. Supress this warning with `_G.PRVDMWRONG_SUPPRESS_MULTIPLE_SAME_TAG = true`.",
})
