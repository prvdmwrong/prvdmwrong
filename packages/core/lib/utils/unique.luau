--!strict
--[[
  Copyright (c) znotfireman 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local UUID_TEMPLATE = "%x%x%x%x%x%x%x%x-%x%x%x%x-4%x%x%x-%x%x%x%x-%x%x%x%x%x%x%x%x%x%x%x%x"
local X_HEX, X_MIN = 0xF, 0
local Y_HEX, Y_MIN = 0xB, 8

--[[
  Generates a new universally unique ID.
]]
local function unique(): string
  math.randomseed(os.clock())
  -- I'm sorry.
  return (
    string.format(
      UUID_TEMPLATE,
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(Y_MIN, Y_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX),
      math.random(X_MIN, X_HEX)
    )
  )
end

return unique
