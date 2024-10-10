local fs = require("@lune/fs")
local path = require("../../utils/path")
local process = require("@lune/process")

type MarkdownTemplates = {
  class: string,
  ["class-item"]: string,
  ["function"]: string,
  ["function-param"]: string,
  ["function-return"]: string,
  main: string,
  ["main-package"]: string,
  package: string,
  ["package-class"]: string,
  ["package-class-item"]: string,
  type: string,
}

type Templates = MarkdownTemplates & {
  get: (templateName: keyof<MarkdownTemplates>) -> string,
}

local PATH_TEMPLATES = path(process.cwd, "lune", "docs", "templates")
local templates: Templates = {} :: any

for _, template in fs.readDir(PATH_TEMPLATES) do
  local templatePath = path(PATH_TEMPLATES, template)
  if not fs.isFile(templatePath) or not template:find("%.md$") then
    continue
  end
  (templates :: any)[template:gsub("%.md$", "")] = fs.readFile(assert(templatePath, "Luau"))
end

function templates.get(templateName: keyof<MarkdownTemplates>): string
  return assert(templates[templateName], "Cannot find documentation template called " .. templateName)
end

return templates
