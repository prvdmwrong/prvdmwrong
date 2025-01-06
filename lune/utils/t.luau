--- t if it wasnt bloated
--- please dont look too closely
local t = {}

function t.type(typeName: string): (value: unknown) -> (boolean, string?)
	return function(value)
		local valueType = type(value)
		if valueType == typeName then
			return true, nil
		else
			return false, string.format("%s expected, got %s", typeName, valueType)
		end
	end
end

function t.typeof(typeName: string): (value: unknown) -> (boolean, string?)
	return function(value)
		local valueType = typeof(value)
		if valueType == typeName then
			return true, nil
		else
			return false, string.format("%s expected, got %s", typeName, valueType)
		end
	end
end

function t.any(value: unknown): (boolean, string?)
	if value ~= nil then
		return true, nil
	else
		return false, "any expected, got nil"
	end
end

t.boolean = t.typeof("boolean")

t.buffer = t.typeof("buffer")

t.thread = t.typeof("thread")

t.callback = t.typeof("function")
t["function"] = t.callback

t.none = t.typeof("nil")
t["nil"] = t.none

t.string = t.typeof("string")

t.table = t.typeof("table")

t.userdata = t.type("userdata")

t.vector = t.type("vector")

function t.number(value: unknown): (boolean, string?)
	local valueType = typeof(value)
	if valueType == "number" then
		if value == value then
			return true, nil
		else
			return false, "unexpected NaN value"
		end
	else
		return false, string.format("number expected, got %s", valueType)
	end
end

function t.nan(value: unknown): (boolean, string?)
	local valueType = typeof(value)
	if valueType == "number" then
		if value ~= value then
			return true, nil
		else
			return false, "unexpected non-NaN value"
		end
	else
		return false, string.format("number expected, got %s", valueType)
	end
end

function t.literal(...: unknown): (value: unknown) -> (boolean, string?)
	local size = select("#", ...)
	if size == 1 then
		local literal = ...
		return function(value)
			if value ~= literal then
				return false, string.format("expected %s, got %s", tostring(literal), tostring(value))
			end

			return true, nil
		end
	else
		local literals = {}
		for i = 1, size do
			local value = select(i, ...)
			literals[i] = t.literal(value)
		end

		return t.union(table.unpack(literals, 1, size))
	end
end

function t.keyOf(keyTable: { [unknown]: unknown }): (value: unknown) -> (boolean, string?)
	local keys = {}
	local length = 0
	for key in pairs(keyTable) do
		length = length + 1
		keys[length] = key
	end

	return t.literal(table.unpack(keys, 1, length))
end

function t.valueOf(valueTable: { [unknown]: unknown }): (value: unknown) -> (boolean, string?)
	local values = {}
	local length = 0
	for _, value in pairs(valueTable) do
		length = length + 1
		values[length] = value
	end

	return t.literal(table.unpack(values, 1, length))
end

function t.integer(value: unknown): (boolean, string?)
	local success, errMsg = t.number(value)
	if not success then
		return false, errMsg or ""
	end

	if value :: number % 1 == 0 then
		return true, nil
	else
		return false, string.format("integer expected, got %s", value :: string)
	end
end

-- Wow osyris
function t.numberMin(min: number): (value: unknown) -> (boolean, string?)
	return function(value)
		local success, errMsg = t.number(value)
		if not success then
			return false, errMsg or ""
		end

		if value :: number >= min then
			return true, nil
		else
			return false, string.format("number >= %s expected, got %s", (min :: any) :: string, value :: string)
		end
	end
end

function t.numberMax(max: number): (value: unknown) -> (boolean, string?)
	return function(value)
		local success, errMsg = t.number(value)
		if not success then
			return false, errMsg
		end

		if value :: number <= max then
			return true, nil
		else
			return false, string.format("number <= %s expected, got %s", (max :: any) :: string, value :: string)
		end
	end
end

function t.numberMinExclusive(min: number): (value: unknown) -> (boolean, string?)
	return function(value)
		local success, errMsg = t.number(value)
		if not success then
			return false, errMsg or ""
		end

		if min < value :: number then
			return true, nil
		else
			return false, string.format("number > %s expected, got %s", (min :: any) :: string, value :: string)
		end
	end
end

function t.numberMaxExclusive(max: number): (value: unknown) -> (boolean, string?)
	return function(value: unknown)
		local success, errMsg = t.number(value)
		if not success then
			return false, errMsg or ""
		end

		if (value :: number) < max then
			return true, nil
		else
			return false, string.format("number < %s expected, got %s", (max :: any) :: string, value :: string)
		end
	end
end

t.numberPositive = t.numberMinExclusive(0)
t.numberNegative = t.numberMaxExclusive(0)

function t.numberConstrained(min: number, max: number): (value: unknown) -> (boolean, string?)
	assert(t.number(min))
	assert(t.number(max))
	local minCheck = t.numberMin(min)
	local maxCheck = t.numberMax(max)

	return function(value)
		local minSuccess, minErrMsg = minCheck(value)
		if not minSuccess then
			return false, minErrMsg or ""
		end

		local maxSuccess, maxErrMsg = maxCheck(value)
		if not maxSuccess then
			return false, maxErrMsg or ""
		end

		return true, nil
	end
end

function t.numberConstrainedExclusive(min: number, max: number): (value: unknown) -> (boolean, string?)
	assert(t.number(min))
	assert(t.number(max))
	local minCheck = t.numberMinExclusive(min)
	local maxCheck = t.numberMaxExclusive(max)

	return function(value)
		local minSuccess, minErrMsg = minCheck(value)
		if not minSuccess then
			return false, minErrMsg or ""
		end

		local maxSuccess, maxErrMsg = maxCheck(value)
		if not maxSuccess then
			return false, maxErrMsg or ""
		end

		return true, nil
	end
end

function t.match(pattern): (value: unknown) -> (boolean, string?)
	assert(t.string(pattern))
	return function(value: unknown)
		local stringSuccess, stringErrMsg = t.string(value)
		if not stringSuccess then
			return false, stringErrMsg
		end

		if not string.match(value :: string, pattern) then
			return false, string.format("%q failed to match pattern %q", (value :: any) :: string, pattern)
		end

		return true, nil
	end
end

function t.optional(check: (value: unknown) -> (boolean, string?)): (value: unknown) -> (boolean, string?)
	assert(t.callback(check))
	return function(value)
		if value == nil then
			return true, nil
		end

		local success, errMsg = check(value)
		if success then
			return true, nil
		else
			return false, string.format("(optional) %s", errMsg or "")
		end
	end
end

function t.tuple(...): (...unknown) -> (boolean, string?)
	local checks = { ... }
	return function(...)
		local args = { ... }
		for i, check in ipairs(checks) do
			local success, errMsg = check(args[i])
			if success == false then
				return false,
					string.format("Bad tuple index #%s:\n\t%s", (i :: any) :: string, (errMsg or "") :: string)
			end
		end

		return true, nil
	end
end

function t.keys(check: (value: unknown) -> (boolean, string?)): (value: unknown) -> (boolean, string?)
	assert(t.callback(check))
	return function(value)
		local tableSuccess, tableErrMsg = t.table(value)
		if tableSuccess == false then
			return false, tableErrMsg or ""
		end

		for key in pairs(value :: any) do
			local success, errMsg = check(key)
			if success == false then
				return false, string.format("bad key %s:\n\t%s", tostring(key), errMsg or "")
			end
		end

		return true, nil
	end
end

function t.values(check: (value: unknown) -> (boolean, string?)): (value: unknown) -> (boolean, string?)
	assert(t.callback(check))
	return function(value)
		local tableSuccess, tableErrMsg = t.table(value)
		if tableSuccess == false then
			return false, tableErrMsg or ""
		end

		for key, val in pairs(value :: any) do
			local success, errMsg = check(val)
			if success == false then
				return false, string.format("bad value for key %s:\n\t%s", tostring(key), errMsg or "")
			end
		end

		return true, nil
	end
end

function t.map(
	keyCheck: (value: unknown) -> (boolean, string?),
	valueCheck: (value: unknown) -> (boolean, string?)
): (value: unknown) -> (boolean, string?)
	assert(t.callback(keyCheck))
	assert(t.callback(valueCheck))
	local keyChecker = t.keys(keyCheck)
	local valueChecker = t.values(valueCheck)

	return function(value)
		local keySuccess, keyErr = keyChecker(value)
		if not keySuccess then
			return false, keyErr or ""
		end

		local valueSuccess, valueErr = valueChecker(value)
		if not valueSuccess then
			return false, valueErr or ""
		end

		return true, nil
	end
end

function t.set(valueCheck: (value: unknown) -> (boolean, string?)): (value: unknown) -> (boolean, string?)
	return t.map(valueCheck, t.literal(true))
end

do
	local arrayKeysCheck = t.keys(t.integer)

	function t.array(check: (value: unknown) -> (boolean, string?)): (value: unknown) -> (boolean, string?)
		assert(t.callback(check))
		local valuesCheck = t.values(check)

		return function(value: unknown)
			local keySuccess, keyErrMsg = arrayKeysCheck(value)
			if keySuccess == false then
				return false, string.format("[array] %s", keyErrMsg or "")
			end

			local arraySize = 0

			for _ in (ipairs :: any)(value) do
				arraySize = arraySize + 1
			end

			for key in pairs(value :: any) do
				if key < 1 or key > arraySize then
					return false, string.format("[array] key %s must be sequential", tostring(key))
				end
			end

			local valueSuccess, valueErrMsg = valuesCheck(value)
			if not valueSuccess then
				return false, string.format("[array] %s", valueErrMsg or "")
			end

			return true, nil
		end
	end

	function t.strictArray<T...>(...: T...): (value: unknown) -> (boolean, string?)
		local valueTypes = { ... }
		assert(t.array(t.callback)(valueTypes))

		return function(value: unknown)
			local keySuccess, keyErrMsg = arrayKeysCheck(value)
			if keySuccess == false then
				return false, string.format("[strictArray] %s", keyErrMsg or "")
			end

			if #(valueTypes :: {}) < #(value :: {}) then
				return false, string.format("[strictArray] Array size exceeds limit of %d", #valueTypes)
			end

			for idx, typeFn in pairs(valueTypes) do
				local typeSuccess, typeErrMsg = (typeFn :: any)((value :: any)[idx])
				if not typeSuccess then
					return false,
						string.format(
							"[strictArray] Array index #%d - %s",
							(idx :: any) :: number,
							typeErrMsg :: string
						)
				end
			end

			return true, nil
		end
	end
end

do
	local callbackArray = t.array(t.callback)

	function t.union(...: (value: unknown) -> (boolean, string?)): (value: unknown) -> (boolean, string?)
		local checks = { ... }
		assert(callbackArray(checks) :: never)

		return function(value)
			for _, check in ipairs(checks) do
				if check(value) then
					return true, nil
				end
			end

			return false, "bad type for union"
		end
	end

	function t.intersection(...: (value: unknown) -> (boolean, string?)): (value: unknown) -> (boolean, string?)
		local checks = { ... }
		assert(callbackArray(checks) :: never)

		return function(value)
			for _, check in ipairs(checks) do
				local success, errMsg = check(value)
				if not success then
					return false, errMsg or ""
				end
			end

			return true, nil
		end
	end
end

do
	local checkInterface = t.map(t.any, t.callback)
	function t.interface(
		checkTable: { [string]: (value: unknown) -> (boolean, string?) }
	): (value: unknown) -> (boolean, string?)
		assert(checkInterface(checkTable))
		return function(value)
			local tableSuccess, tableErrMsg = t.table(value)
			if tableSuccess == false then
				return false, tableErrMsg or ""
			end

			for key, check in pairs(checkTable :: any) do
				local success, errMsg = check((value :: any)[key] :: any)
				if success == false then
					return false,
						string.format("[interface] bad value for %s:\n\t%s", tostring(key), (errMsg or "") :: string)
				end
			end

			return true, nil
		end
	end

	function t.strictInterface(
		checkTable: { string: (value: unknown) -> (boolean, string?) }
	): (value: unknown) -> (boolean, string?)
		assert(checkInterface(checkTable))
		return function(value)
			local tableSuccess, tableErrMsg = t.table(value)
			if tableSuccess == false then
				return false, tableErrMsg or ""
			end

			for key, check in pairs(checkTable :: any) do
				local success, errMsg = check((value :: any)[key])
				if success == false then
					return false,
						string.format("[interface] bad value for %s:\n\t%s", tostring(key), (errMsg or "") :: string)
				end
			end

			for key in pairs(value :: any) do
				if not (checkTable :: any)[key] then
					return false, string.format("[interface] unexpected field %q", tostring(key))
				end
			end

			return true, nil
		end
	end
end

do
	local checkWrap = t.tuple(t.callback, t.callback)

	function t.wrap<Args..., Returns...>(
		callback: (Args...) -> Returns...,
		checkArgs: (...unknown) -> (boolean, string?)
	): (Args...) -> Returns...
		assert(checkWrap(callback, checkArgs))
		return function(...: Args...): Returns...
			assert((checkArgs :: any)(... :: any) :: any)
			return callback(...)
		end :: any
	end
end

function t.strict<T...>(check: (T...) -> (boolean, string?)): (T...) -> ()
	return function(...)
		assert(check(...))
	end :: any
end

return t
