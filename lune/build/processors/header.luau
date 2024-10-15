local configs = require("@lunescripts/_utils/configs")
local fs = require("@lune/fs")
local path = require("@lunescripts/_utils/path")
local types = require("@lunescripts/types")

local FileHeader = {} :: types.BuildProcessor

local header = table.concat(configs.repoConfig.publish.header, "\n")
header ..= "\n\n"

local function processFiles(cwd: string)
	for _, file in fs.readDir(cwd) do
		local filepath = path(cwd, file)
		if fs.isDir(filepath) then
			processFiles(filepath :: string)
			continue
		end
		if fs.isFile(filepath :: string) and file:match("%.luau$") then
			print("    Writing file header for", filepath)
			fs.writeFile(filepath :: string, header .. fs.readFile(filepath :: string))
		end
	end
end

function FileHeader:process(package: types.BuildPackage)
	print("  Writing file headers")
	processFiles(path(package.outputPath, "src"))
end

return FileHeader
