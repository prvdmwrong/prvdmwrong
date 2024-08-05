--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local WEAK_KEYS_METATABLE = { __mode = "k" }

local metadata = setmetatable({} :: any, WEAK_KEYS_METATABLE) :: {
  [unknown]: {
    [string]: unknown,
  },
}

local Reflect = {}
Reflect.idToObject = {} :: { [string]: unknown }
Reflect.objectToId = {} :: { [unknown]: string }

--[[
  Returns the identifier of an object, suffixed by an optional string.
]]
function Reflect.getIdentifier(object: unknown, suffix: string?): string
  local identifier = Reflect.getMetadata(object, "identifier")
  if typeof(identifier) == "string" then
    return identifier .. (suffix or "")
  end
  return "unidentifiedProvider" .. (suffix or "")
end

--[[
  Defines a piece of metadata. Use the "identifier" key to set a custom
  identifier which Prvd 'M Wrong will respect.
]]
function Reflect.defineMetadata(object: unknown, key: string, value: unknown)
  if key == "identifier" then
    assert(typeof(value) == "string", "identifier must be a string.")
    assert(not Reflect.objectToId[object], "obj is already registered.")
    assert(not Reflect.idToObject[value], "id is already registered.")

    Reflect.objectToId[object] = value
    Reflect.idToObject[value] = object
  end

  if not metadata[object] then
    metadata[object] = {}
  end
  metadata[object][key] = value
end

--[[
  Retrieves a piece of metadata from an object.
]]
function Reflect.getMetadata(object: unknown, key: string): unknown?
  local result = metadata[object] and metadata[object][key]
  return result
end

--[[
  Deletes a piece of metadata from an object.
]]
function Reflect.deleteMetadata(object: unknown, key: string)
  if metadata[object] then
    metadata[object][key] = nil
  end
end

table.freeze(Reflect)
return Reflect
