local types = require("../types")

local DocsGenerator = {} :: types.Generator
DocsGenerator.type = "Generator"
DocsGenerator.of = "documentation"

function DocsGenerator:generate(packages) end

return DocsGenerator
