--!strict
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.

local freeThreads: { thread } = {}
local Threads = {}

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
function Threads.spawn<Args...>(resume: (Args...) -> (), ...: Args...)
  local thread: thread
  if #freeThreads > 0 then
    thread = assert(table.remove(freeThreads, #freeThreads), "Luau")
  else
    thread = coroutine.create(yield)
    coroutine.resume(thread)
  end
  task.spawn(thread, resume, thread, ...)
end

table.freeze(Threads)
return Threads
