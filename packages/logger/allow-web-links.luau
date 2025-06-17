local runtime = require("../runtime")

local allowWebLinks = if runtime.name == "roblox" then game:GetService("RunService"):IsStudio() else true

return allowWebLinks
