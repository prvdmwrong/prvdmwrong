local types = require("./types")

type Set<T> = { [T]: true }

local providerClasses: Set<types.Provider<any>> = setmetatable({}, { __mode = "k" }) :: any

return providerClasses
