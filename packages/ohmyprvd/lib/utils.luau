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

local package = script.Parent
local log = require(package.log)
local types = require(package.types)
local expect = log.expect
local parseError = log.parseError

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
function utils.isPromise(x: unknown): boolean
  if typeof(x) ~= "table" then
    return false
  end

  local x = x :: { [any]: any }

  local metatable = getmetatable(x :: any)
  if metatable == nil then
    return isCallable(x.andThen) and isCallable(x.awaitStatus)
  end

  local hasMetatable = type(metatable) == "table" and type(metatable.__index) == "table"
  return hasMetatable and isCallable(metatable.__index.andThen) and isCallable(metatable.__index.awaitStatus)
end

--[[
  Preload the specified parent by requiring all ModuleScripts within it. Optional
  `predicate` functions can be provided to filter modules.
]]
function utils.preload(instances: { Instance }, ...: ((ModuleScript) -> boolean)?)
  local exports: { unknown } = {}
  local predicates: { ((ModuleScript) -> boolean)? } = { ... }
  for _, module in ipairs(instances) do
    if not module:IsA("ModuleScript") then
      continue
    end
    if #predicates > 0 then
      local failed: boolean = false
      for _, predicate in ipairs(predicates) do
        if typeof(predicate) == "function" and not predicate(module) then
          failed = true
          break
        end
      end
      if failed then
        continue
      end
    end
    local ok, result: types.Error = xpcall(require, parseError, module)
    expect(ok, "requireError", result.trace, module:GetFullName(), result.message)
    table.insert(exports, result)
  end
  return exports
end

table.freeze(utils)
return utils
