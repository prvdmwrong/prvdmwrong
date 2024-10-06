-- I need a pysch eval

local StringBuilder = require("../../utils/string-builder")
local fs = require("@lune/fs")
local path = require("../../utils/path")
local process = require("@lune/process")
local serde = require("@lune/serde")
local stringer = require("../../utils/stringer")
local types = require("../types")

type DocumentationCategory = {
  content: string,
  kinds: {
    [string]: {
      [string]: string,
    },
  },
}

type MoonwaveType = {
  desc: string,
  lua_type: string,
}

type MoonwaveFunctionParameter = MoonwaveType & {
  name: string,
}

type MoonwaveSource = {
  line: number,
  path: string,
}

type MoonwaveFunction = {
  name: string,
  desc: string,
  function_type: "static",
  since: string?,
  params: { MoonwaveFunctionParameter },
  returns: { MoonwaveType },
  source: MoonwaveSource,
}

type MoonwaveClass = {
  name: string,
  desc: string,
  since: string?,
  source: MoonwaveSource,
  functions: { MoonwaveFunction },
  types: { unknown },
  properties: { unknown },
}

type MoonwaveDocumentation = { MoonwaveClass }

local PATH_DOCS = path(process.cwd, "docs")
local PATH_API_REFERENCE = path(PATH_DOCS, "api-reference")
local GITHUB_ROOT_URL = "https://github.com/prvdmwrong/prvdmwrong/tree/0.2"

local DocsGenerator = {} :: types.Generator
DocsGenerator.type = "Generator"
DocsGenerator.of = "documentation"

do
  local testMoonwave = process.spawn("moonwave-extractor", { "-V" })
  if not testMoonwave.ok then
    print("  Missing `moonwave-extractor`, download it via `cargo install moonwave`")
    process.exit(1)
  end
end

function DocsGenerator:generate(packages)
  if not fs.isDir(PATH_API_REFERENCE) then
    fs.writeDir(assert(PATH_API_REFERENCE, "Luau"))
  else
    fs.removeDir(assert(PATH_API_REFERENCE, "Luau"))
    fs.writeDir(PATH_API_REFERENCE :: any)
  end

  for _, package in packages do
    print("  Documenting", package.relativePath)
    local result = process.spawn("moonwave-extractor", { "extract", package.relativePath })

    if not result.ok then
      print("    Moonwave threw an error while extracting", package.relativePath)
      print("    " .. result.stdout:gsub("\n", "\n    "))
      print("    " .. result.stderr:gsub("\n", "\n    "))
      process.exit(1)
    end

    local pages: { [string]: DocumentationCategory } = {}

    local moonwaveDocumentation: MoonwaveDocumentation = serde.decode("json", result.stdout)
    for _, class in moonwaveDocumentation do
      local functionSubpages: { [string]: string } = {}

      local mainPage = StringBuilder()
        :appendLine("<!-- This file was @generated and should not be edited. -->")
        :appendLine("<!-- Run `lune run regen` to generate fresh documentation. -->")
        :appendLine()
        :appendLine("#", class.name)
        :appendLine()
        :appendLine(class.desc)
        :appendLine()

      local mainPageItems = {}

      for _, fn in class.functions do
        print("    Documenting", fn.name, "at", fn.source.path, "line", tostring(fn.source.line))

        -- stylua: ignore
        table.insert(
          mainPageItems,
          StringBuilder()
            :appendLine('<section class="prvdmwrong-api-item">')
            :appendLine('<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>')
            :appendLine('<section class="prvdmwrong-api-iteminfo">')
            :appendLine(`<a href="./functions/{fn.name:lower()}">{fn.name}</a>`)
            :appendLine(fn.desc)
            :appendLine("</section>")
            :appendLine("</section>")
            :appendLine()
            :build()
        )

        local functionSignature = StringBuilder():appendLine("function", `{package.config.module}.{fn.name}(`)
        local functionDocumentation = StringBuilder()

        if next(fn.params) ~= nil then
          functionDocumentation:appendLine("---"):appendLine():appendLine("## Parameters"):appendLine()
          for _, param in fn.params do
            functionSignature:appendLine(`\t{param.name}:`, param.lua_type)
            functionDocumentation
              :appendLine('<h3 class="prvdmwrong-api-param">')
              :appendLine(param.name)
              :appendLine('<span class="prvdmwrong-api-type">:', param.lua_type, "</span>")
              :appendLine("</h3>")
              :appendLine()
              :appendLine(param.desc)
              :appendLine()
          end
        end

        if next(fn.returns) ~= nil then
          local returnSignatures = {}
          local returnDescriptions = {}
          for _, returnSignature in fn.returns do
            table.insert(returnSignatures, returnSignature.lua_type)
            table.insert(returnDescriptions, returnSignature.desc)
          end
          functionSignature:appendLine("):", stringer.cleanNewlines(table.concat(returnSignatures, ", ")))
          functionDocumentation
            :appendLine("---")
            :appendLine()
            :appendLine('<h2 class="prvdmwrong-api-returns">')
            :appendLine("Returns")
            :appendLine('<span class="prvdmwrong-api-type">:', table.concat(returnSignatures, ", "), "</span>")
            :appendLine("</h2>")
            :appendLine()
            :appendLine(table.concat(returnDescriptions, ". "))
        else
          functionSignature:appendLine("): ()")
        end

        local url = path(GITHUB_ROOT_URL, package.relativePath, fn.source.path)
        local sinceVersion = fn.since or "unknown"
        local sinceLabel = StringBuilder()
          :appendLine(`<span class="prvdmwrong-api-since", title="Since version {sinceVersion}">`)
          :appendLine("since", sinceVersion)
          :appendLine("</span>")

        -- stylua: ignore
        functionSubpages[fn.name:lower()] = StringBuilder()
          :appendLine("<!-- This file was @generated and should not be edited. -->")
          :appendLine("<!-- Run `lune run regen` to generate fresh documentation. -->")
          :appendLine()
          :appendLine('<h1 class="prvdmwrong-api-top">')
          :appendLine("<span>")
          :appendLine('<span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">function</span>')
          :appendLine('<span class="prvdmwrong-api-header">', fn.name, "</span>")
          :appendLine("</span>")
          :appendLine('<span class="prvdmwrong-api-labels">')
          :appendStringBuilder(sinceLabel)
          :appendLine(`<a class="prvdmwrong-api-source" href={url}#L{fn.source.line} title="View source code on GitHub">`)
          :appendLine("view source")
          :appendLine("</a>")
          :appendLine("</span>")
          :appendLine("</h1>")
          :appendLine()
          :appendLine("```Luau")
          :appendStringBuilder(functionSignature)
          :appendLine("```")
          :appendLine()
          :appendLine(fn.desc)
          :appendLine()
          :appendStringBuilder(functionDocumentation)
          :build()
      end

      table.sort(mainPageItems)

      pages[class.name:lower()] = {
        content = mainPage
          :appendLine('<section class="prvdmwrong-api-items">')
          :appendLine(table.concat(mainPageItems))
          :appendLine("</section>")
          :build(),
        kinds = {
          functions = functionSubpages,
        },
      }
    end

    for pageName, page in pages do
      local pageDirectory = path(PATH_API_REFERENCE, package.name, pageName)
      if not fs.isDir(pageDirectory) then
        fs.writeDir(assert(pageDirectory, "Luau"))
      end
      fs.writeFile(path(pageDirectory, "index.md"), page.content)
      for kind, subpages in page.kinds do
        local kindDirectory = path(pageDirectory, kind)
        if not fs.isDir(kindDirectory) then
          fs.writeDir(assert(kindDirectory, "Luau"))
        end
        for subpageName, subpage in subpages do
          fs.writeFile(path(kindDirectory, subpageName .. ".md"), subpage)
        end
      end
    end
  end
end

return DocsGenerator
