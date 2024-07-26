--!strict
--!nolint LocalShadow

--[[

  Copyright 2024 Team Fireworks

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the “Software”), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so,subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

]]

export type None = {
  __ohmyprvd_none__: never,
}

type GetObjectMetadata =
  ((object: unknown, property: string?, create: true) -> { [string]: unknown })
  & ((object: unknown, property: string?) -> { [string]: unknown }?)

local WEAK_KEYS_METATABLE = { __mode = "k" }
local NONE: None = newproxy(true)
getmetatable(NONE :: any).__tostring = function()
  return "ohmyprvd.none"
end

local metadata = setmetatable({} :: any, WEAK_KEYS_METATABLE) :: {
  -- object
  [unknown]: {
    -- property
    [string | None]: {
      -- key: value
      [string]: unknown,
    },
  },
}

local reflect = {}
reflect.none = NONE
reflect.idToObject = {} :: { [string]: unknown }
reflect.objectToId = {} :: { [unknown]: string }

local getObjectMetadata: GetObjectMetadata = function(
  object: unknown,
  property: string?,
  create: boolean?
): { [string]: unknown }?
  local property = property or NONE
  local objectMetadata = metadata[object]
  if not create then
    if objectMetadata then
      return objectMetadata[property]
    end
    return nil
  end
  if not objectMetadata then
    metadata[object] = {}
  end
  local propertyMetadata = metadata[object][property]
  if not propertyMetadata then
    metadata[object][property] = {}
  end
  return propertyMetadata
end :: GetObjectMetadata

function reflect.defineMetadata(object: unknown, key: string, value: unknown, property: string?)
  if key == "identifier" then
    assert(typeof(value) == "string", "identifier must be a string.")
    assert(not reflect.objectToId[object], "obj is already registered.")
    assert(not reflect.idToObject[value], "id is already registered.")

    reflect.objectToId[object] = value
    reflect.idToObject[value] = object
  end

  local metadata = getObjectMetadata(object, property, true)
  metadata[key] = value
end

function reflect.getOwnMetadata(object: unknown, key: string, property: string?): unknown?
  local metadata = getObjectMetadata(object, property)
  if metadata then
    return metadata[key]
  end
  return nil
end

function reflect.deleteMetadata(object: unknown, key: string, property: string?)
  local metadata = getObjectMetadata(object, property)
  if metadata then
    metadata[key] = nil
  end
end

table.freeze(reflect)
return reflect
