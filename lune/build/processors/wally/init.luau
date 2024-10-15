local types = require("@lunescripts/types")

local NPM = {} :: types.BuildProcessor

function NPM:process(package: types.BuildPackage) end

function NPM:publish(package: types.BuildPackage) end

return NPM
