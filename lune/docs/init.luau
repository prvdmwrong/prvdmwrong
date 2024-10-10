-- I need a pysch eval

local Moonwave = require("./moonwave")
local StringBuilder = require("../utils/string-builder")
local UsageInstructions = require("./usage")
local config = require("./config")
local datetime = require("@lune/datetime")
local fs = require("@lune/fs")
local path = require("../utils/path")
local process = require("@lune/process")
local serde = require("@lune/serde")
local stringer = require("../utils/stringer")
local templates = require("./templates")
local types = require("./types")

type BuildMetadata = {
  build: {
    generated_at: string,
    generated_files: { string },
  },
}

local PATH_DOCS = path(process.cwd, "docs")
local PATH_API_REFERENCE = path(PATH_DOCS, "api-reference")
local PATH_PACKAGES_RELATIVE = path("prvdmwrong")
local PATH_PACKAGES = path(process.cwd, PATH_PACKAGES_RELATIVE)
local GITHUB_ROOT_URL = "https://github.com/prvdmwrong/prvdmwrong/blob/0.2"
local PATH_DOC_BUILD = path(process.cwd, "doc.build")

local packages: { types.PackageData } = {}
local generatedPages: { string } = {}

local function reset()
  if fs.isFile(PATH_DOC_BUILD) then
    local docBuild: BuildMetadata = serde.decode("toml", fs.readFile(assert(PATH_DOC_BUILD, "Luau")))
    print("Removing old files from previous build generated at", docBuild.build.generated_at)
    for _, file in docBuild.build.generated_files do
      if fs.isFile(file) then
        print("  Removing file", file)
        fs.removeFile(file)
      end
    end
  end
end

local function functionSignature(moonwaveFunction: Moonwave.MoonwaveFunction): StringBuilder.StringBuilder
  local signature = StringBuilder(moonwaveFunction.name .. "(")

  if next(moonwaveFunction.params) ~= nil then
    signature:appendLn()
    for _, functionParameter in moonwaveFunction.params do
      signature:appendLn(`\t{functionParameter.name}:`, functionParameter.lua_type)
    end
  end

  if next(moonwaveFunction.returns) ~= nil then
    local returns = {}
    for _, functionReturn in moonwaveFunction.returns do
      table.insert(returns, functionReturn.lua_type)
    end
    signature:append("):", stringer.cleanNewlines(table.concat(returns, ", ")))
  else
    signature:append("): ()")
  end

  return signature
end

local function writePages(pages: { [string]: StringBuilder.StringBuilder }, dir: string): { string }
  if not fs.isDir(dir) then
    fs.writeDir(assert(dir, "Luau"))
  end

  local pathsWritten = {}
  for name, builder in pages do
    local pagePath = path(dir, name) .. ".md"
    print("    Writing file", pagePath)
    table.insert(pathsWritten, pagePath)
    table.insert(generatedPages, pagePath)
    fs.writeFile(pagePath, builder:build())
  end

  return pathsWritten
end

for _, package in fs.readDir(PATH_PACKAGES) do
  if not fs.isDir(path(PATH_PACKAGES, package)) then
    continue
  end

  local configPath = path(PATH_PACKAGES, package, "config.toml")
  assert(fs.isFile(configPath), `Missing prvdmwrong/{package} config.toml`)
  local packageConfig = config.from(serde.decode("toml", fs.readFile(assert(configPath, "Luau is wilding"))))

  table.insert(packages, {
    name = package,
    config = packageConfig,
    absolutePath = path(PATH_PACKAGES, package),
    relativePath = path(PATH_PACKAGES_RELATIVE, package),
  })
end

reset()

for _, package in packages do
  print("Documenting package", package.relativePath)

  local extracted = Moonwave.extract(package.relativePath)
  local packageSections: { [string]: StringBuilder.StringBuilder } = {}

  for _, class in extracted do
    print("  Documenting class", class.name)

    local functionPages: { [string]: StringBuilder.StringBuilder } = {}
    local typePages: { [string]: StringBuilder.StringBuilder } = {}

    local classItems: { [string]: StringBuilder.StringBuilder } = {}
    local packageClassItems: { [string]: StringBuilder.StringBuilder } = {}
    local classNames: { string } = {}

    ---

    for _, classFunction in class.functions do
        -- stylua: ignore
        print(`    Documenting function {classFunction.name} defined at {classFunction.source.path:gsub("^src/", "")} line {classFunction.source.line}`)

      local parameters = StringBuilder()
      local returns = StringBuilder()
      local signature = functionSignature(classFunction)

      if next(classFunction.params) ~= nil then
        parameters:appendLn():appendLn("## Parameters"):appendLn()
      end

      for _, functionParameter in classFunction.params do
        local template = templates
          .get("function-param")
          :gsub("$name", functionParameter.name)
          :gsub("$lua_type", functionParameter.lua_type)
          :gsub("$description", functionParameter.desc)
        parameters:appendLn(template)
      end

      if next(classFunction.returns) ~= nil then
        returns:appendLn():appendLn("## Returns"):appendLn()
      end

      for _, functionReturn in classFunction.returns do
        local template = templates
          .get("function-return")
          :gsub("$lua_type", functionReturn.lua_type)
          :gsub("$description", functionReturn.desc)
        returns:appendLn(template)
      end

      local githubSource = path(GITHUB_ROOT_URL, package.relativePath, classFunction.source.path)
      githubSource ..= `#L{classFunction.source.line}`

      functionPages[classFunction.name:lower()] = StringBuilder(
        templates
          .get("function")
          :gsub("$name", classFunction.name)
          :gsub("$signature", signature:build())
          :gsub("$description", classFunction.desc)
          :gsub("$source_url", githubSource)
      ):appendStringBuilder(parameters):appendStringBuilder(returns)

      table.insert(classNames, classFunction.name)
      classItems[classFunction.name] = StringBuilder(
        templates
          .get("class-item")
          :gsub("$kind_title", "Function")
          :gsub("$kind_symbol", "f")
          :gsub("$kind", "function")
          :gsub("$class", class.name:lower())
          :gsub("$identifier", classFunction.name:lower())
          :gsub("$name", classFunction.name)
          :gsub("$description", classFunction.desc)
      )

      packageClassItems[classFunction.name] = StringBuilder(
        templates
          .get("class-item")
          :gsub("$kind_title", "Function")
          :gsub("$kind_symbol", "f")
          :gsub("$kind", "function")
          :gsub("$class", class.name:lower())
          :gsub("$identifier", classFunction.name:lower())
          :gsub("$name", classFunction.name)
          :gsub("$description", classFunction.desc)
      )
    end

    ---

    for _, classType in class.types do
        -- TODO: types
        -- stylua: ignore
        print(`    Documenting type {classType.name} at {classType.source.path:gsub("^src/", "")} line {classType.source.line}`)

      local typeIdentifier = assert(classType.name:match("%w+"), "Unreachable")
      table.insert(classNames, typeIdentifier)

      local githubSource = path(GITHUB_ROOT_URL, package.relativePath, classType.source.path)
      githubSource ..= `#L{classType.source.line}`

      typePages[typeIdentifier:lower()] = StringBuilder(
        templates
          .get("type")
          :gsub("$name", classType.name)
          :gsub("$description", classType.desc)
          :gsub("$source_url", githubSource)
      )

      classItems[typeIdentifier] = StringBuilder(
        templates
          .get("class-item")
          :gsub("$kind_title", "Type definition")
          :gsub("$kind_symbol", "T")
          :gsub("$kind", "type")
          :gsub("$class", class.name:lower())
          :gsub("$identifier", typeIdentifier:lower())
          :gsub("$name", classType.name)
          :gsub("$description", classType.desc)
      )

      packageClassItems[typeIdentifier] = StringBuilder(
        templates
          .get("package-class-item")
          :gsub("$kind_title", "Type definition")
          :gsub("$kind_symbol", "T")
          :gsub("$kind", "type")
          :gsub("$class", class.name:lower())
          :gsub("$identifier", typeIdentifier:lower())
          :gsub("$name", classType.name)
          :gsub("$description", classType.desc)
      )
    end

    ---

    table.sort(classNames)
    local sortedClassItems = StringBuilder()
    local sortedPackageClassItems = StringBuilder()
    for _, class in classNames do
      local itemBuilder = classItems[class]
      sortedClassItems:appendStringBuilder(itemBuilder)
      local packageItemBuilder = packageClassItems[class]
      sortedPackageClassItems:appendStringBuilder(packageItemBuilder)
    end

    local classPage = StringBuilder(
      templates
        .get("class")
        :gsub("$name", class.name)
        :gsub("$description", class.desc)
        :gsub("$class_items", sortedClassItems:build())
    )

    packageSections[class.name] = StringBuilder(
      templates
        .get("package-class")
        :gsub("$name", class.name)
        :gsub("$description", class.desc)
        :gsub("$class_items", sortedPackageClassItems:build())
    )

    writePages(functionPages, path(PATH_API_REFERENCE, package.name, class.name:lower(), "functions"))
    writePages(typePages, path(PATH_API_REFERENCE, package.name, class.name:lower(), "types"))
    writePages({ index = classPage }, path(PATH_API_REFERENCE, package.name, class.name:lower()))
  end

  local sortedPackageSections = StringBuilder()
  for _, class in package.config.docs.classes do
    sortedPackageSections:appendStringBuilder(packageSections[class])
  end

  -- TODO: consider extracting this into templates
  local usageSelect = StringBuilder()
    :appendLn('<section class="prvdmwrong-api-usewith" markdown>')
    :appendLn('<nav class="usage-instructions-nav">')
    :appendLn("Use with")
    :appendLn('<select id="usage-instructions-select">')

  local usageInstructions = StringBuilder()
  for _, packageInstructions in UsageInstructions do
    -- stylua: ignore start
    usageSelect:appendLn(`<option value="{packageInstructions.packageManager:lower()}">{packageInstructions.packageManager}</option>`)
    usageInstructions:appendLn(`<section class="usage-instructions-package usage-instructions-{packageInstructions.packageManager:lower()}">`)
    -- stylua: ignore end

    for _, instruction in packageInstructions.instructions do
      usageInstructions
        :appendLn('<span class="usage-instructions-title">')
        :appendLn(instruction.title)
        :appendLn("</span>")
        :appendLn()
        :appendLn("```" .. instruction.language)
        :appendLn(instruction.code(package :: types.PackageData))
        :appendLn("```")
        :appendLn()
    end

    usageInstructions:appendLn("</section>")
  end

  usageSelect:appendLn("</select>"):appendLn("</nav>")

    -- stylua: ignore
    local packageUsageInstructions = StringBuilder()
      :appendStringBuilder(usageSelect)
      :appendStringBuilder(usageInstructions)

  local packagePage = StringBuilder(
    templates
      .get("package")
      :gsub("$name", package.name)
      :gsub("$technical_description", package.config.description.technical)
      :gsub("$class_sections", sortedPackageSections:build())
      :gsub("$usage_instructions", packageUsageInstructions:build())
  )

  writePages({ index = packagePage }, path(PATH_API_REFERENCE, package.name))
  fs.writeFile(
    PATH_DOC_BUILD,
    StringBuilder()
      :appendLn("# This file was @generated and is not intended for manual editing.")
      :appendLn("# It is used to store metadata between documentation builds.")
      :appendLn("# Run `lune run regen` to generate fresh documentation files.")
      :appendLn()
      :appendLn(serde.encode("toml", {
        build = {
          generated_at = datetime.now():toIsoDate(),
          generated_files = generatedPages,
        },
      }, true))
      :build()
  )
end
