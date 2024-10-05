local freeThreads: { thread } = {}
local threads = {}

local function resume<Args...>(resume: (Args...) -> (), thread: thread, ...)
  resume(...)
  table.insert(freeThreads, thread)
end

local function yield()
  while true do
    resume(coroutine.yield())
  end
end

function threads.spawn<Args...>(resume: (Args...) -> (), ...: Args...)
  local thread: thread
  if #freeThreads > 0 then
    thread = assert(table.remove(freeThreads, #freeThreads), "Luau")
  else
    thread = coroutine.create(yield)
    coroutine.resume(thread)
  end
  task.spawn(thread, resume, thread, ...)
end

function threads.spawnCallbacks<Args...>(callbacks: { (Args...) -> () }, ...: Args...)
  for _, callback in callbacks do
    threads.spawn(callback, ...)
  end
end

table.freeze(threads)
return threads
