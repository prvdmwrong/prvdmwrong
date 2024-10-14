local types = require("../types")

local build = {}

function build.buildPackages(context: {
  packages: { types.Package },
  isDistributing: boolean,
  version: string,
})
  for _, package in context.packages do
    print("Building", package.relativePath)
  end
end

return build
