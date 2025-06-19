local fs = require("@lune/fs")
local types = require("@compile/types")

local NpmCompiler = {} :: types.Compiler & types.Publisher
NpmCompiler.implements = { Compiler = true :: true, Publisher = true :: true }
NpmCompiler.label = "npm"

function NpmCompiler:compile(ctx) end

function NpmCompiler:publish(ctx)
	local distNpmDir = `{ctx.distDir}/npm/`
	fs.writeDir(distNpmDir)

	for _, package in ctx.packages do
	end
end

return NpmCompiler
