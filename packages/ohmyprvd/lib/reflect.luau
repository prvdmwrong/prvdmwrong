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
