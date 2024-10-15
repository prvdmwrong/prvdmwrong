--[=[
  osyrisrblx/t trimmed down without Roblox typedefs while being fully typed.
]=]
local tiny = {}

export type Checker<T> = ((value: T) -> true) & ((value: unknown) -> (false, string))

function tiny.type<T>(check: Checker<T>): T
	error("this is for static typechecking purposes, eg. type MyType = typeof(t.type(MyType))")
end

function tiny.typeof(typeName: string): Checker<any>
	return function(value)
		local valueType = typeof(value)
		if valueType == typeName then
			return true
		else
			return false, string.format("%s expected, got %s", typeName, valueType)
		end
	end
end

local function tiny_any(value)
	if value ~= nil then
		return true
	else
		return false, "any expected, got nil"
	end
end

tiny.any = tiny_any :: Checker<any>

tiny.boolean = tiny.typeof("boolean") :: Checker<boolean>
tiny.buffer = tiny.typeof("buffer") :: Checker<buffer>
tiny.thread = tiny.typeof("thread") :: Checker<thread>
tiny.callback = tiny.typeof("function") :: Checker<(...unknown) -> ...unknown>
tiny.none = tiny.typeof("nil") :: Checker<nil>
tiny.string = tiny.typeof("string") :: Checker<string>
tiny.table = tiny.typeof("table") :: Checker<{ [unknown]: unknown }>
tiny.userdata = tiny.typeof("userdata") :: Checker<userdata>
tiny.vector = tiny.typeof("vector") :: Checker<unknown>

local function tiny_number(value)
	local valueType = typeof(value)
	if valueType == "number" then
		if value == value then
			return true
		else
			return false, "unexpected NaN value"
		end
	else
		return false, string.format("number expected, got %s", valueType)
	end
end

tiny.number = tiny_number :: Checker<number>

local function tiny_integer(value)
	local success, errMsg = tiny.number(value)
	if not success then
		return false, errMsg or ""
	end

	if value % 1 == 0 then
		return true
	else
		return false, string.format("integer expected, got %s", value)
	end
end

tiny.integer = tiny_integer :: Checker<number>

function tiny.literal(...)
	local size = select("#", ...)
	if size == 1 then
		local literal = ...
		return function(value)
			if value ~= literal then
				return false, string.format("expected %s, got %s", tostring(literal), tostring(value))
			end

			return true
		end
	else
		local literals = {}
		for i = 1, size do
			local value = select(i, ...)
			literals[i] = tiny.literal(value)
		end

		return tiny.union(table.unpack(literals, 1, size))
	end
end

function tiny.keyOf(keyTable)
	local keys = {}
	local length = 0
	for key in pairs(keyTable) do
		length = length + 1
		keys[length] = key
	end

	return tiny.literal(table.unpack(keys, 1, length))
end

function tiny.valueOf(valueTable)
	local values = {}
	local length = 0
	for _, value in pairs(valueTable) do
		length = length + 1
		values[length] = value
	end

	return tiny.literal(table.unpack(values, 1, length))
end

function tiny.match(pattern: string): Checker<string>
	assert(tiny.string(pattern))
	return function(value)
		local stringSuccess, stringErrMsg = tiny.string(value)
		if not stringSuccess then
			return false, stringErrMsg
		end

		if string.match(value, pattern) == nil then
			return false, string.format("%q failed to match pattern %q", value, pattern)
		end

		return true
	end
end

function tiny.optional<T>(check: Checker<T>): Checker<T?>
	assert(tiny.callback(check))
	return function(value)
		if value == nil then
			return true
		end

		local success, errMsg = check(value)
		if success then
			return true
		else
			return false, string.format("(optional) %s", errMsg or "")
		end
	end
end

type TupleChecker<T...> = ((T...) -> true) & ((...unknown) -> false)
function tiny.tuple<T...>(...: T...): TupleChecker<T...>
	local checks = { ... }
	return function(...)
		local args = { ... }
		for i, check in ipairs(checks) do
			local success, errMsg = check(args[i])
			if success == false then
				return false, string.format("Bad tuple index #%s:\n\t%s", i, errMsg or "")
			end
		end

		return true
	end
end

function tiny.keys<Key>(check: Check<Key>): Check<{ [Key]: unknown }>
	assert(tiny.callback(check))
	return function(value)
		local tableSuccess, tableErrMsg = tiny.table(value)
		if tableSuccess == false then
			return false, tableErrMsg or ""
		end

		for key in pairs(value) do
			local success, errMsg = check(key)
			if success == false then
				return false, string.format("bad key %s:\n\t%s", tostring(key), errMsg or "")
			end
		end

		return true
	end
end

function tiny.values<Value>(check: Check<Value>): Check<{ [unknown]: Value }>
	assert(tiny.callback(check))
	return function(value)
		local tableSuccess, tableErrMsg = tiny.table(value)
		if tableSuccess == false then
			return false, tableErrMsg or ""
		end

		for key, val in pairs(value) do
			local success, errMsg = check(val)
			if success == false then
				return false, string.format("bad value for key %s:\n\t%s", tostring(key), errMsg or "")
			end
		end

		return true
	end
end

function tiny.map<Key, Value>(keyCheck: Check<Key>, valueCheck: Check<Value>): Check<{ [Key]: Value }>
	assert(tiny.callback(keyCheck))
	assert(tiny.callback(valueCheck))
	local keyChecker = tiny.keys(keyCheck)
	local valueChecker = tiny.values(valueCheck)

	return function(value)
		local keySuccess, keyErr = keyChecker(value)
		if not keySuccess then
			return false, keyErr or ""
		end

		local valueSuccess, valueErr = valueChecker(value)
		if not valueSuccess then
			return false, valueErr or ""
		end

		return true
	end
end

function tiny.set<Value>(valueCheck: Value): Check<{ [Value]: true }>
	return tiny.map(valueCheck, tiny.literal(true))
end

do
	local arrayKeysCheck = tiny.keys(tiny.integer)

	function tiny.array(check)
		assert(tiny.callback(check))
		local valuesCheck = tiny.values(check)

		return function(value)
			local keySuccess, keyErrMsg = arrayKeysCheck(value)
			if keySuccess == false then
				return false, string.format("[array] %s", keyErrMsg or "")
			end

			-- # is unreliable for sparse arrays
			-- Count upwards using ipairs to avoid false positives from the behavior of #
			local arraySize = 0

			for _ in ipairs(value) do
				arraySize = arraySize + 1
			end

			for key in pairs(value) do
				if key < 1 or key > arraySize then
					return false, string.format("[array] key %s must be sequential", tostring(key))
				end
			end

			local valueSuccess, valueErrMsg = valuesCheck(value)
			if not valueSuccess then
				return false, string.format("[array] %s", valueErrMsg or "")
			end

			return true
		end
	end

	function tiny.strictArray(...)
		local valueTypes = { ... }
		assert(tiny.array(tiny.callback)(valueTypes))

		return function(value)
			local keySuccess, keyErrMsg = arrayKeysCheck(value)
			if keySuccess == false then
				return false, string.format("[strictArray] %s", keyErrMsg or "")
			end

			-- If there's more than the set array size, disallow
			if #valueTypes < #value then
				return false, string.format("[strictArray] Array size exceeds limit of %d", #valueTypes)
			end

			for idx, typeFn in pairs(valueTypes) do
				local typeSuccess, typeErrMsg = typeFn(value[idx])
				if not typeSuccess then
					return false, string.format("[strictArray] Array index #%d - %s", idx, typeErrMsg)
				end
			end

			return true
		end
	end
end

do
	local callbackArray = tiny.array(tiny.callback)

	function tiny.union(...)
		local checks = { ... }
		assert(callbackArray(checks))

		return function(value)
			for _, check in ipairs(checks) do
				if check(value) then
					return true
				end
			end

			return false, "bad type for union"
		end
	end

	tiny.some = tiny.union

	function tiny.intersection(...)
		local checks = { ... }
		assert(callbackArray(checks))

		return function(value)
			for _, check in ipairs(checks) do
				local success, errMsg = check(value)
				if not success then
					return false, errMsg or ""
				end
			end

			return true
		end
	end

	tiny.every = tiny.intersection
end

do
	local checkInterface = tiny.map(tiny.any, tiny.callback)

	function tiny.interface(checkTable)
		assert(checkInterface(checkTable))
		return function(value)
			local tableSuccess, tableErrMsg = tiny.table(value)
			if tableSuccess == false then
				return false, tableErrMsg or ""
			end

			for key, check in pairs(checkTable) do
				local success, errMsg = check(value[key])
				if success == false then
					return false, string.format("[interface] bad value for %s:\n\t%s", tostring(key), errMsg or "")
				end
			end

			return true
		end
	end

	function tiny.strictInterface(checkTable)
		assert(checkInterface(checkTable))
		return function(value)
			local tableSuccess, tableErrMsg = tiny.table(value)
			if tableSuccess == false then
				return false, tableErrMsg or ""
			end

			for key, check in pairs(checkTable) do
				local success, errMsg = check(value[key])
				if success == false then
					return false, string.format("[interface] bad value for %s:\n\t%s", tostring(key), errMsg or "")
				end
			end

			for key in pairs(value) do
				if not checkTable[key] then
					return false, string.format("[interface] unexpected field %q", tostring(key))
				end
			end

			return true
		end
	end
end

function tiny.instanceOf(className, childTable)
	assert(tiny.string(className))

	local childrenCheck
	if childTable ~= nil then
		childrenCheck = tiny.children(childTable)
	end

	return function(value)
		local instanceSuccess, instanceErrMsg = tiny.Instance(value)
		if not instanceSuccess then
			return false, instanceErrMsg or ""
		end

		if value.ClassName ~= className then
			return false, string.format("%s expected, got %s", className, value.ClassName)
		end

		if childrenCheck then
			local childrenSuccess, childrenErrMsg = childrenCheck(value)
			if not childrenSuccess then
				return false, childrenErrMsg
			end
		end

		return true
	end
end

tiny.instance = tiny.instanceOf

function tiny.instanceIsA(className, childTable)
	assert(tiny.string(className))

	local childrenCheck
	if childTable ~= nil then
		childrenCheck = tiny.children(childTable)
	end

	return function(value)
		local instanceSuccess, instanceErrMsg = tiny.Instance(value)
		if not instanceSuccess then
			return false, instanceErrMsg or ""
		end

		if not value:IsA(className) then
			return false, string.format("%s expected, got %s", className, value.ClassName)
		end

		if childrenCheck then
			local childrenSuccess, childrenErrMsg = childrenCheck(value)
			if not childrenSuccess then
				return false, childrenErrMsg
			end
		end

		return true
	end
end

function tiny.enum(enum)
	assert(tiny.Enum(enum))
	return function(value)
		local enumItemSuccess, enumItemErrMsg = tiny.EnumItem(value)
		if not enumItemSuccess then
			return false, enumItemErrMsg
		end

		if value.EnumType == enum then
			return true
		else
			return false, string.format("enum of %s expected, got enum of %s", tostring(enum), tostring(value.EnumType))
		end
	end
end

do
	local checkWrap = tiny.tuple(tiny.callback, tiny.callback)

	function tiny.wrap(callback, checkArgs)
		assert(checkWrap(callback, checkArgs))
		return function(...)
			assert(checkArgs(...))
			return callback(...)
		end
	end
end

function tiny.strict(check)
	return function(...)
		assert(check(...))
	end
end

do
	local checkChildren = tiny.map(tiny.string, tiny.callback)

	function tiny.children(checkTable)
		assert(checkChildren(checkTable))

		return function(value)
			local instanceSuccess, instanceErrMsg = tiny.Instance(value)
			if not instanceSuccess then
				return false, instanceErrMsg or ""
			end

			local childrenByName = {}
			for _, child in ipairs(value:GetChildren()) do
				local name = child.Name
				if checkTable[name] then
					if childrenByName[name] then
						return false, string.format("Cannot process multiple children with the same name %q", name)
					end

					childrenByName[name] = child
				end
			end

			for name, check in pairs(checkTable) do
				local success, errMsg = check(childrenByName[name])
				if not success then
					return false, string.format("[%s.%s] %s", value:GetFullName(), name, errMsg or "")
				end
			end

			return true
		end
	end
end

return tiny
