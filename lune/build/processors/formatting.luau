local configs = require("@scripts/_configs")
local fs = require("@lune/fs")
local path = require("@scripts/_utils/path")
local summon = require("@scripts/_utils/summon")
local types = require("@scripts/build/types")

type BrokenLuau = never

local header = table.concat(configs.repoConfig.publish.header, "\n")
header ..= "\n\n"

local FormattingProcessor = {} :: types.Processor
FormattingProcessor.processesWhat = "formatting including Stylua"

local function processFiles(cwd: string, context: types.BuildContext)
	for _, file in fs.readDir(cwd) do
		local filepath = path(cwd, file)
		if fs.isDir(filepath) :: BrokenLuau then
			processFiles(filepath :: string, context)
			continue
		end
		if fs.isFile(filepath) :: BrokenLuau and file:match("%.luau$") then
			context.log.print("Writing file header for", filepath)
			fs.writeFile(filepath, header .. fs.readFile(filepath))
		end
	end
end

function FormattingProcessor:process(package: types.Package, context: types.BuildContext)
	local packageSource = path(package.outputPath, "src")
	summon("stylua", packageSource)
	context.log.indent()
	processFiles(packageSource, context)
	context.log.unIndent()
end

return FormattingProcessor
