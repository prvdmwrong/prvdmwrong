local fs = require("@lune/fs")
local types = require("@compile/types")

local WallyCompiler = {} :: types.Compiler & types.Publisher
WallyCompiler.implements = { Compiler = true :: true, Publisher = true :: true }
WallyCompiler.label = "wally"

function WallyCompiler:compile(ctx)
	local distWallyDir = `{ctx.distDir}/wally/`
	fs.writeDir(distWallyDir)

	for _, package in ctx.packages do
	end
end

function WallyCompiler:publish(ctx) end

return WallyCompiler
