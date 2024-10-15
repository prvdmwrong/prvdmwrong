--!strict
-- Tx is Prvd 'M Wrong fully typed mix of osyrisrblx/t and dphfox/ty

local Maybe = require("./maybe")

type Type<T> = {
	expectsType: string,
	typeError: string,
	matches: (self: Type<T>, value: unknown) -> boolean,
	assert: (self: Type<T>, value: unknown) -> T,
	cast: (self: Type<T>, value: unknown) -> Maybe.Maybe<T>,
}

type LuauPrimitives = {
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

type CheckablePrimitives = LuauPrimitives & {
	Axes: Axes,
	BrickColor: BrickColor,
	CFrame: CFrame,
	Color3: Color3,
	ColorSequence: ColorSequence,
	ColorSequenceKeypoint: ColorSequenceKeypoint,
	DateTime: DateTime,
	DockWidgetPluginGuiInfo: DockWidgetPluginGuiInfo,
	Enum: Enum,
	EnumItem: EnumItem,
	Enums: Enums,
	Faces: Faces,
	FloatCurveKey: FloatCurveKey,
	Font: Font,
	Instance: Instance,
	NumberRange: NumberRange,
	NumberSequence: NumberSequence,
	NumberSequenceKeypoint: NumberSequenceKeypoint,
	OverlapParams: OverlapParams,
	PathWaypoint: PathWaypoint,
	PhysicalProperties: PhysicalProperties,
	Random: Random,
	Ray: Ray,
	RaycastParams: RaycastParams,
	RaycastResult: RaycastResult,
	RBXScriptConnection: RBXScriptConnection,
	RBXScriptSignal: RBXScriptSignal,
	Rect: Rect,
	Region3: Region3,
	Region3int16: Region3int16,
	TweenInfo: TweenInfo,
	UDim: UDim,
	UDim2: UDim2,
	Vector2: Vector2,
	Vector2int16: Vector2int16,
	Vector3: Vector3,
	Vector3int16: Vector3int16,
}

local Tx = {}

local function typechecker(
	expectsType: string,
	cast: (self: Type<unknown>, value: unknown) -> Maybe.Maybe<unknown>
): Type<unknown>
	local typedef = {} :: Type<unknown>
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
function Tx.static<T>(typechecker: Type<T>): T
  -- stylua: ignore
  error("Not for runtime usage, used to get static type of a typechecker eg. `type MyType = typeof(Tx.static(MyType))`")
end

-- NOTE: Luau throws a shitload of errors here. Dw it still typechecks
function Tx.primitive<Primitive>(primitive: Primitive & keyof<CheckablePrimitives>): Type<index<CheckablePrimitives, Primitive>>
	return typechecker(primitive, function(self, value): Maybe.Maybe<unknown>
		local realType = typeof(primitive)
		if realType == self.expectsType then
			return Maybe.some(value)
		end
		return Maybe.none(`Expected Roblox primitive type {self.expectsType}, got {realType}`)
	end)
end

-- These still type checks properly so I dont give a fuck
Tx.buffer = Tx.primitive("buffer")
Tx.callback = Tx.primitive("function")
Tx.number = Tx.primitive("number")
Tx.none = Tx.primitive("nil")
Tx.string = Tx.primitive("string")
Tx.table = Tx.primitive("table")
Tx.thread = Tx.primitive("thread")
Tx.userdata = Tx.primitive("userdata")
Tx.vector = Tx.primitive("vector")

Tx.Axes = Tx.primitive("Axes")
Tx.BrickColor = Tx.primitive("BrickColor")
Tx.CFrame = Tx.primitive("CFrame")
Tx.Color3 = Tx.primitive("Color3")
Tx.ColorSequence = Tx.primitive("ColorSequence")
Tx.ColorSequenceKeypoint = Tx.primitive("ColorSequenceKeypoint")
Tx.DateTime = Tx.primitive("DateTime")
Tx.DockWidgetPluginGuiInfo = Tx.primitive("DockWidgetPluginGuiInfo")
Tx.Enum = Tx.primitive("Enum")
Tx.Enums = Tx.primitive("Enums")
Tx.Faces = Tx.primitive("Faces")
Tx.FloatCurveKey = Tx.primitive("FloatCurveKey")
Tx.Font = Tx.primitive("Font")
Tx.Instance = Tx.primitive("Instance")
Tx.NumberRange = Tx.primitive("NumberRange")
Tx.NumberSequence = Tx.primitive("NumberSequence")
Tx.NumberSequenceKeypoint = Tx.primitive("NumberSequenceKeypoint")
Tx.OverlapParams = Tx.primitive("OverlapParams")
Tx.PathWaypoint = Tx.primitive("PathWaypoint")
Tx.PhysicalProperties = Tx.primitive("PhysicalProperties")
Tx.Random = Tx.primitive("Random")
Tx.Ray = Tx.primitive("Ray")
Tx.RaycastParams = Tx.primitive("RaycastParams")
Tx.RaycastResult = Tx.primitive("RaycastResult")
Tx.RBXScriptConnection = Tx.primitive("RBXScriptConnection")
Tx.RBXScriptSignal = Tx.primitive("RBXScriptSignal")
Tx.Rect = Tx.primitive("Rect")
Tx.Region3 = Tx.primitive("Region3")
Tx.Region3int16 = Tx.primitive("Region3int16")
Tx.UDim = Tx.primitive("UDim")
Tx.Vector2 = Tx.primitive("Vector2")
Tx.Vector2int16 = Tx.primitive("Vector2int16")
Tx.Vector3 = Tx.primitive("Vector3")
Tx.Vector3int16 = Tx.primitive("Vector3int16")

function Tx.optional<T>(type: Type<T>): Type<T?>
	return typechecker(type.expectsType .. "?", function(self, value): Maybe.Maybe<unknown>
		if value == nil then
			return Maybe.some(value :: any)
		end

		return type:cast(value)
	end)
end

function Tx.just<T>(literal: T, type: string?): Type<T>
	return typechecker(type or tostring(literal), function(self, value): Maybe.Maybe<unknown>
		if rawequal(value, literal) then
			return Maybe.some(value)
		end
		return Maybe.none(self.typeError)
	end)
end

function Tx.keys<Key>(keyType: Type<Key>): Type<{ [Key]: unknown }>
	Tx.callback:assert(keyType)
	return typechecker(`\{ [{keyType.expectsType}]: unknown }`, function(self, value): Maybe.Maybe<unknown>
		local maybeTable = Tx.table:cast(value)
		if not maybeTable.some then
			return Maybe.none(maybeTable.error)
		end

		for key in value :: any do
			local maybeKey = keyType:cast(key)
			if not maybeKey.some then
				return Maybe.none(`Bad key {tostring(key)} of type {typeof(key)}: {maybeKey.error}`)
			end
		end

		return Maybe.some(value)
	end) :: any
end

function Tx.values<Value>(valueType: Type<Value>): Type<{ [unknown]: Value }>
	Tx.callback:assert(valueType)
	return typechecker(`\{ [unknown]: {valueType.expectsType} }`, function(self, value): Maybe.Maybe<unknown>
		local maybeTable = Tx.table:cast(value)
		if not maybeTable.some then
			return Maybe.none(maybeTable.error)
		end

		for _, value in value :: any do
			local maybeValue = valueType:cast(value)
			if not maybeValue.some then
				return Maybe.none(`Bad value {tostring(value)} of type {typeof(value)}: {maybeValue.error}`)
			end
		end

		return Maybe.some(value)
	end) :: any
end

function Tx.map<Key, Value>(keyType: Type<Key>, valueType: Type<Value>): Type<{ [Key]: Value }>
	Tx.callback:assert(keyType)
	Tx.callback:assert(valueType)
	return typechecker(
		`\{ [{keyType.expectsType}]: {valueType.expectsType} }`,
		function(self, value): Maybe.Maybe<unknown>
			local maybeTable = Tx.table:cast(value)
			if not maybeTable.some then
				return Maybe.none(maybeTable.error)
			end

			for key, value in value :: any do
				local maybeKey = keyType:cast(key)
				if not maybeKey.some then
					return Maybe.none(`Bad key {tostring(key)} of type {typeof(key)}: {maybeKey.error}`)
				end

				local maybeValue = valueType:cast(value)
				if not maybeValue.some then
					return Maybe.none(`Bad value {tostring(value)} of type {typeof(value)}: {maybeValue.error}`)
				end
			end

			return Maybe.some(value)
		end
	) :: any
end

local trueType = Tx.just(true)
function Tx.set<Value>(valueType: Value): Type<{ [Value]: true }>
	return Tx.map(valueType, trueType) :: any
end

do
	local arrayKeys = Tx.keys(Tx.number)
end

--[=[

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

]=]

table.freeze(Tx)
return Tx
