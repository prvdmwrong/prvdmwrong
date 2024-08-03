--!strict
--!nolint LocalShadow
-- Oh My Prvd code licensed under MIT
local WEAK_KEYS_METATABLE = { __mode = "k" }

local metadata = setmetatable({} :: any, WEAK_KEYS_METATABLE) :: {
  [unknown]: {
    [string]: unknown,
  },
}

local reflect = {}
reflect.idToObject = {} :: { [string]: unknown }
reflect.objectToId = {} :: { [unknown]: string }

function reflect.defineMetadata(object: unknown, key: string, value: unknown)
  if key == "identifier" then
    assert(typeof(value) == "string", "identifier must be a string.")
    assert(not reflect.objectToId[object], "obj is already registered.")
    assert(not reflect.idToObject[value], "id is already registered.")

    reflect.objectToId[object] = value
    reflect.idToObject[value] = object
  end

  if not metadata[object] then
    metadata[object] = {}
  end
  metadata[object][key] = value
end

function reflect.getMetadata(object: unknown, key: string): unknown?
  local result = metadata[object] and metadata[object][key]
  return result
end

function reflect.deleteMetadata(object: unknown, key: string)
  if metadata[object] then
    metadata[object][key] = nil
  end
end

table.freeze(reflect)
return reflect
