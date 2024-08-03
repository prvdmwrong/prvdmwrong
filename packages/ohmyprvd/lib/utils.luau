--!strict
--!nolint LocalShadow
-- Oh My Prvd code licensed under MIT

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
  Preload the specified parent by requiring all ModuleScripts within it. An
  optional `predicate` function can be provided to filter modules.
]]
function utils.preload(instances: { Instance }, predicate: ((ModuleScript) -> boolean)?)
  local exports: { unknown } = {}
  for _, module in ipairs(instances) do
    if not module:IsA("ModuleScript") then
      continue
    end
    if predicate and not predicate(module) then
      continue
    end
    local ok, result: types.Error = xpcall(require, parseError, module)
    expect(ok, "requireError", result.trace, module:GetFullName(), result.message)
    table.insert(exports, result)
  end
  return exports
end

table.freeze(utils)
return utils
