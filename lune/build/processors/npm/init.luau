local types = require("@lunescripts/types")

local NPM = {} :: types.BuildProcessor

function NPM:process(package: types.Package) end

function NPM:publish(package: types.Package) end

return NPM
