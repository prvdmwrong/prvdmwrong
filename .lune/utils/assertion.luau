--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local process = require("@lune/process")

local assertion: typeof(assert) = function<T>(condition: T, errorMessage: string?): T
	if condition then
		return condition
	end

	print(errorMessage or "Assertion failed")
	print(debug.traceback("Stack trace", 3))
	return process.exit(1)
end

return assertion
