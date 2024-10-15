--!strict
-- Tx is Prvd 'M Wrong fully typed mix of osyrisrblx/t and dphfox/ty

local Maybe = require("./maybe")

type Typechecker<T> = {
	expectsType: string,
	typeError: string,
	matches: (self: Typechecker<T>, value: unknown) -> boolean,
	assert: (self: Typechecker<T>, value: unknown) -> T,
	cast: (self: Typechecker<T>, value: unknown) -> Maybe.Maybe<T>,
}

type PrimitiveTypes = {
	buffer: buffer,
	["function"]: (...unknown) -> ...unknown,
	["nil"]: nil,
	number: number,
	string: string,
	table: { [unknown]: unknown },
	thread: thread,
	userdata: unknown,
	vector: unknown,
}

local Tx = {}

local function typechecker(
	expectsType: string,
	cast: (self: Typechecker<unknown>, value: unknown) -> Maybe.Maybe<unknown>
): Typechecker<unknown>
	local typedef = {} :: Typechecker<unknown>
	typedef.expectsType = expectsType
	typedef.typeError = `Type is not {expectsType}`
	typedef.cast = cast

	function typedef:matches(value)
		return cast(value).some
	end

	function typedef:assert(value)
		local maybe = cast(value)
		assert(maybe.some, (maybe :: any).error)
		return maybe.value
	end

	table.freeze(typedef)
	return typedef
end

-- FUTURE: promote to type function
function Tx.static<T>(typechecker: Typechecker<T>): T
  -- stylua: ignore
  error("Not for runtime usage, used to get static type of a typechecker eg. `type MyType = typeof(Tx.static(MyType))`")
end

-- NOTE: Luau throws a shitload of errors here. Dw it still typechecks
function Tx.primitive<Primitive>(primitive: Primitive & keyof<PrimitiveTypes>): Typechecker<index<PrimitiveTypes, Primitive>>
	return typechecker(primitive, function(self, value): Maybe.Maybe<unknown>
		local realType = type(primitive)
		if realType == self.expectsType then
			return Maybe.some(value)
		end
		return Maybe.none(`Expected primitive type {self.expectsType}, got {realType}`)
	end)
end

Tx.buffer = Tx.primitive("buffer")
Tx.callback = Tx.primitive("function")
Tx.number = Tx.primitive("number")
Tx.none = Tx.primitive("nil")
Tx.string = Tx.primitive("string")
Tx.table = Tx.primitive("table")
Tx.thread = Tx.primitive("thread")
Tx.userdata = Tx.primitive("userdata")
Tx.vector = Tx.primitive("vector")

function Tx.optional<T>(type: Typechecker<T>): Typechecker<T?>
	return typechecker(type.expectsType .. "?", function(self, value): Maybe.Maybe<unknown>
		if value == nil then
			return Maybe.some(value :: any)
		end

		return type:cast(value)
	end)
end

function Tx.just<T>(literal: T, type: string?): Typechecker<T>
	return typechecker(type or tostring(literal), function(self, value): Maybe.Maybe<unknown>
		if rawequal(value, literal) then
			return Maybe.some(value)
		end
		return Maybe.none(self.typeError)
	end)
end

-- function Tx.keys<Key>(check: Check<Key>): Check<{ [Key]: unknown }>
--   assert(tiny.callback(check))
--   return function(value)
--     local tableSuccess, tableErrMsg = tiny.table(value)
--     if tableSuccess == false then
--       return false, tableErrMsg or ""
--     end

--     for key in pairs(value) do
--       local success, errMsg = check(key)
--       if success == false then
--         return false, string.format("bad key %s:\n\t%s", tostring(key), errMsg or "")
--       end
--     end

--     return true
--   end
-- end

-- function Tx.values<Value>(check: Check<Value>): Check<{ [unknown]: Value }>
--   assert(callback(check))
--   return function(value)
--     local tableSuccess, tableErrMsg = tiny.table(value)
--     if tableSuccess == false then
--       return false, tableErrMsg or ""
--     end

--     for key, val in pairs(value) do
--       local success, errMsg = check(val)
--       if success == false then
--         return false, string.format("bad value for key %s:\n\t%s", tostring(key), errMsg or "")
--       end
--     end

--     return true
--   end
-- end

-- function Tx.map<Key, Value>(key: Check<Key>, valueCheck: Check<Value>): Check<{ [Key]: Value }>
--   assert(callback(keyCheck))
--   assert(callback(valueCheck))
--   local keyChecker = tiny.keys(keyCheck)
--   local valueChecker = tiny.values(valueCheck)

--   return function(value)
--     local keySuccess, keyErr = keyChecker(value)
--     if not keySuccess then
--       return false, keyErr or ""
--     end

--     local valueSuccess, valueErr = valueChecker(value)
--     if not valueSuccess then
--       return false, valueErr or ""
--     end

--     return true
--   end
-- end

-- function tiny.set<Value>(valueCheck: Value): Check<{ [Value]: true }>
--   return tiny.map(valueCheck, tiny.literal(true))
-- end

table.freeze(Tx)
return Tx
