-- Original implementation from https://github.com/pesde-pkg/tooling/blob/main/toolchainlib/src/utils/progress.luau

local stdio = require("@lune/stdio")
local task = require("@lune/task")

-- FORMAT: {SPINNER} {MESSAGE} {BAR} {STAGE}
local SPINNERS = { "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local BAR_COMPONENT = "▇"
local MAX_BAR_LENGTH = 30

local ProgressBar = {}
type ProgressBar = {
	stages: { { tag: string, message: string } },
	currentStageIndex: number,
	finished: boolean,
	thread: thread?,
}
export type ProgressBarImpl = typeof(setmetatable({} :: ProgressBar, { __index = ProgressBar }))

function ProgressBar.new(): ProgressBarImpl
	return setmetatable(
		{
			stages = {},
			currentStageIndex = 1,
			finished = false,
		} :: ProgressBar,
		{
			__index = ProgressBar,
		}
	)
end

function ProgressBar.withStage(self: ProgressBarImpl, tag: string, msg: string): ProgressBarImpl
	table.insert(self.stages, { tag = tag, message = msg })
	return self
end

function ProgressBar.start(self: ProgressBarImpl): ()
	local BAR_LENGTH = MAX_BAR_LENGTH // #self.stages
	local TOTAL_BAR_LENGTH = BAR_LENGTH * #self.stages
	local BAR = string.rep(BAR_COMPONENT, BAR_LENGTH)
	local MAX_MESSAGE_LENGTH = 0
	for _, stage in self.stages do
		local len = #stage.message
		if len > MAX_MESSAGE_LENGTH then
			MAX_MESSAGE_LENGTH = len
		end
	end

	self.thread = task.spawn(function()
		while not self.finished do
			for _, spinner in SPINNERS do
				local stage = self.stages[self.currentStageIndex]
				stdio.write(
					`\x1b[2K\x1b[0G{stdio.color("cyan")}{spinner} {stage.message}{stdio.color("reset")}{string.rep(
						" ",
						MAX_MESSAGE_LENGTH - #stage.message
					)} [{stdio.style("dim")}{string.rep(BAR, self.currentStageIndex)}{string.rep(
						" ",
						TOTAL_BAR_LENGTH - (BAR_LENGTH * self.currentStageIndex)
					)}{stdio.style("reset")}] {stdio.style("bold")}{self.currentStageIndex} / {#self.stages}{stdio.style(
						"reset"
					)}`
				)

				task.wait(0.1)
			end
		end
	end)
end

function ProgressBar.stop(self: ProgressBarImpl): ()
	-- Trigger upvalue, kill thread and clean progress bar remnant
	self.finished = true
	task.cancel(self.thread :: thread)
	stdio.write("\x1b[2K\x1b[0G")
end

function ProgressBar.nextStage(self: ProgressBarImpl)
	local inc = self.currentStageIndex + 1
	if inc > #self.stages then
		-- TODO: Make this a result
		self.finished = true
		error("attempted to advance past last stage")
	end

	self.currentStageIndex = inc
	return
end

return ProgressBar
