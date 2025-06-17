local implementations = require("@self/implementations")
local task = require("@self/libs/task")
local threadpool = require("@self/batteries/threadpool")
local warn = require("@self/libs/warn")

export type RuntimeName = implementations.RuntimeName

return table.freeze({
	runtime = implementations.currentRuntime,

	task = task,
	warn = warn,

	threadpool = threadpool,
})
