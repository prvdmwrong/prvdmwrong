local fs = require("@lune/fs")
local path = require("@scripts/_utils/path")
local serde = require("@lune/serde")
local types = require("@scripts/build/types")

local RojoProcessor = {} :: types.Processor
RojoProcessor.processesWhat = "default.project.json files"

function RojoProcessor:process(package: types.Package, context: types.BuildContext)
	fs.writeFile(
		path(package.outputPath, "default.project.json"),
		serde.encode("json", {
			name = package.packageName,
			tree = {
				["$path"] = "src",
			},
		})
	)
end

return RojoProcessor
