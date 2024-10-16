local path = require("@scripts/_utils/path")
local process = require("@lune/process")
local types = require("@scripts/build/types")

local PATH_DARKLUA = path(process.cwd, "darklua.json")

local DarkluaProcessor = {} :: types.Processor
DarkluaProcessor.processesWhat = "source files via Darklua"
DarkluaProcessor.loadOrder = -math.huge

function DarkluaProcessor:process(package: types.Package, context: types.BuildContext)
	local darkluaProcess = process.spawn(
		"darklua",
		{ "process", "-c", PATH_DARKLUA, "-vvvv", path(package.absolutePath, "src"), path(package.outputPath, "src") },
		{
			env = {
				PRVDMWRONG_BUILD = tostring(context.isDistributing),
				PRVDMWRONG_VERSION = context.version,
			},
			cwd = process.cwd,
			shell = true,
		} :: process.SpawnOptions
	)

	if not darkluaProcess.ok then
		context.log.print(darkluaProcess.stdout)
		context.log.print(darkluaProcess.stderr)
		context.log.print("Darklua process failed with code", tostring(darkluaProcess.code))
		process.exit(1)
	end
end

return DarkluaProcessor
