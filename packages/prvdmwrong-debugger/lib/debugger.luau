-- local package = script.Parent
-- local Fusion = require(package.packages.Fusion)
-- local prvd = require(package.packages.prvd)

-- local authorizePlayer: ((Player) -> boolean)? = nil

-- local debugger = {}
-- type Self = typeof(debugger)
-- debugger.loadOrder = 0

-- function debugger:onInit()
--   local scope = Fusion:scoped()
-- end

-- function debugger.authorize(authorize: (Player) -> boolean)
--   assert(not authorizePlayer, "cannot set authorize player twice")
--   authorizePlayer = authorizePlayer
-- end

-- return prvd.new("ohmyprvd-debugger", debugger)
