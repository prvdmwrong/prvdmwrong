--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local freeThreads: { thread } = {}
local utils = {}

local function isCallable(value)
  if type(value) == "function" then
    return true
  end

  if type(value) == "table" then
    local metatable = getmetatable(value)
    if metatable and typeof(metatable.__call) == "function" then
      return true
    end
  end

  return false
end

local function resume<Args...>(resume: (Args...) -> (), thread: thread, ...)
  resume(...)
  table.insert(freeThreads, thread)
end

local function yield()
  while true do
    resume(coroutine.yield())
  end
end

--[[
  Spawns a thread immediately. This will pool and reuse threads when possible,
  and thus is more efficient than `task.spawn`.
]]
function utils.spawn<Args...>(resume: (Args...) -> (), ...: Args...)
  local thread: thread
  if #freeThreads > 0 then
    thread = assert(table.remove(freeThreads, #freeThreads), "Luau")
  else
    thread = coroutine.create(yield)
    coroutine.resume(thread)
  end
  task.spawn(thread, resume, thread, ...)
end

--[[
  Checks whether the given object is a Promise via duck typing. This only checks
  if the object is a table and has an `andThen` method.
]]
function utils.isPromise(promise: unknown): boolean
  if typeof(promise) ~= "table" then
    return false
  end

  local metatable = getmetatable(promise :: any)
  if metatable == nil then
    return isCallable((promise :: { [any]: any }).andThen) and isCallable((promise :: { [any]: any }).awaitStatus)
  end

  local hasMetatable = typeof(metatable) == "table" and typeof(metatable.__index) == "table"
  return hasMetatable and isCallable(metatable.__index.andThen) and isCallable(metatable.__index.awaitStatus)
end

table.freeze(utils)
return utils
