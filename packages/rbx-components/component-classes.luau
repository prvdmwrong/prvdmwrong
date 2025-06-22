local types = require("./types")

type Set<T> = { [T]: true }

local componentClasses: Set<types.Component<any>> = setmetatable({}, { __mode = "k" }) :: any

return componentClasses
