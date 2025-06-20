local logger = require("../logger")
local types = require("../types")

local function destroy(root: types.Self)
	if root._destroyed then
		logger:fatalError({ template = logger.alreadyDestroyed })
	end
	root._destroyed = true
	table.clear(root._rootLifecycles)
	table.clear(root._rootProviders)
	table.clear(root._subRoots)
	root._start:clear()
	root._finish:clear()
end

return destroy
