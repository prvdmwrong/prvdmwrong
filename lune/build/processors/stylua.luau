local summon = require("@lunescripts/utils/summon")
local types = require("@lunescripts/types")

local Stylua = {} :: types.BuildProcessor

function Stylua:process(package: types.BuildPackage)
  print("  Formatting output via Stylua")
  summon("stylua", package.outputPath)
end

return Stylua
