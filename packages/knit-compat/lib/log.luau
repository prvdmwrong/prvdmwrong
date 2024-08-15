--!strict
--[[
  Copyright (c) znotfireman 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local alreadyWarned: { [string]: true } = {}
local log = {}

function log.expect<T>(condition: T, message: string, ...: unknown): T
  if condition then
    return condition
  end
  error(`[prvdmwrong(knitCompat)]: {message:format(...)}`)
end

function log.noPrvd(): never
  error(
    `[prvdmwrong(noPrvd)]: cannot find the core @prvdmwrong/core package, try requiring prvdmwrong earlier to register it as a global`
  )
end

function log.warnDeprecated(recommendedApi: string, deprecatedApi: string, context: string)
  if alreadyWarned[deprecatedApi] then
    return
  end
  alreadyWarned[deprecatedApi] = true
  warn(`[prvdmwrong(knitDeprecated)]: use {recommendedApi} instead of {deprecatedApi}; {context}`)
end

table.freeze(log)
return log
