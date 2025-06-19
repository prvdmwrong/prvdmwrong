local fs = require("@lune/fs")
local types = require("@compile/types")

local RbxmCompiler = {} :: types.Compiler
RbxmCompiler.implements = { Compiler = true }
RbxmCompiler.label = "rbxm"

function RbxmCompiler:compile(ctx)
	local distRbxmDir = `{ctx.distDir}/rbxms/`
	fs.writeDir(distRbxmDir)

	for _, package in ctx.packages do
	end
end

return RbxmCompiler
