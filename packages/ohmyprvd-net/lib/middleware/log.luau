-- local Package = script.Parent.Parent
-- local Types = require(Package.Types)

-- local function Log(): Types.Middleware
--   local logMiddleware = {} :: Types.Middleware
--   logMiddleware.type = "Middleware"

--   function logMiddleware:run(remote)
--     local isFunction = remote.type == "NetFunction"
--     return function(player, ...)
--       return true
--     end
--   end

--   return logMiddleware
-- end

-- return Log
