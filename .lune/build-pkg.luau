local fs = require("@lune/fs")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local stdio = require("@lune/stdio")

type Config = {
  config: {
    name: string,
    display: string,
    description: string,
    dependencies: { string }?,
  },
}

local NPM_SCOPE = "prvdmwrong"
local NPM_PACKAGE = {
  main = "lib/init.luau",
  author = "znotfireman <znotfireman+hello@gmail.com>",
  license = "MIT",
  types = "lib/index.d.ts",
  files = {
    "lib",
    "!**/*.tsbuildinfo",
  },
  publishConfig = {
    access = "public",
  },
  devDependencies = {
    ["@rbxts/compiler-types"] = "2.3.0-types.1",
    ["@rbxts/types"] = "^1.0.790",
    ["roblox-ts"] = "^2.3.0",
    typescript = "^5.5.4",
  },
}

local WALLY_SCOPE = "prvdmwrong"
local WALLY_PACKAGE = {
  package = {
    license = "MIT",
    authors = { "znotfireman <znotfireman+hello@gmail.com>" },
    realm = "shared",
    repository = "https://github.com/prvdmwrong/prvdmwrong",
    registry = "https://github.com/UpliftGames/wally-index",
    include = { "./lib", "./default.project.json" },
    exclude = { "node_modules" },
  },
}

local PESDE_SCOPE = "prvdmwrong"
local PESDE_PACKAGE = {
  license = "MIT",
  authors = { "znotfireman <znotfireman+hello@gmail.com>" },
  realm = "shared",
  repository = "https://github.com/prvdmwrong/prvdmwrong",
  indices = {
    default = "https://github.com/daimond113/pesde-index",
  },
  exports = {
    lib = "./lib/init.luau",
  },
  dependencies = {},
}

local PROJECT_FILE = {
  tree = {
    ["$path"] = "lib",
  },
}

local cwd = process.cwd

local function assertion<T>(condition: T, message: string): T
  if condition then
    return condition
  end
  stdio.ewrite(message)
  return process.exit(1)
end

local function spawnCommand(program: string, ...: string)
  local arguments = { ... }
  -- print(`=> {program} {table.concat(arguments, " ")}`)
  local result = process.spawn(program, arguments, {
    shell = true,
  })
  assertion(result.ok, `Process failed with code {result.code}:\n{result.stderr}`)
end

do
  -- local args = process.args
  -- local shouldRelease: boolean = nil
  -- local shouldBuildRbxms: boolean = nil
  -- local packages: { string } = nil
  -- local version: string = nil
  -- if #args ~= 0 then
  --   if table.find(args, "release") then
  --     shouldRelease = true
  --   end

  --   local versionSpecifier = table.find(args, "-v")
  --   if versionSpecifier then
  --     local specifiedVersion = assertion(args[versionSpecifier], "Must specify version if used -v")
  --     version = specifiedVersion
  --   end

  --   if table.find(args, "--rbxm") then
  --     shouldBuildRbxms = true
  --   end
  -- end

  local packages = {}
  for _, package in ipairs(fs.readDir(`{cwd}/packages`)) do
    if fs.isFile(`{cwd}/packages/{package}`) then
      continue
    end
    table.insert(packages, package)
  end
  table.sort(packages)

  local selected = stdio.prompt("multiselect", "Select packages to build, or none to build all packages", packages)
  local selectedPackages = {}
  if #selected == 0 then
    selectedPackages = packages
  else
    for _, index in ipairs(selected) do
      table.insert(selectedPackages, packages[index])
    end
  end

  local shouldBuildRbxms = stdio.prompt("confirm", "Build .rbxm models?")
  local shouldRelease = stdio.prompt("confirm", "Publish these packages to NPM and Wally?")
  local version = "0.0.0-dev"
  if shouldRelease then
    local promptedVersion = stdio.prompt("text", "Semver version to publish as?")
    assertion(promptedVersion:match("^(%d+)%.?(%d*)%.?(%d*)(.-)$") ~= nil, `{version} is not a valid semver version`)
    version = promptedVersion
  end

  local action, versionMessage =
    shouldRelease and "Releasing" or "Building", version and ` for version {version}` or " for development"
  print(`{action} {table.concat(selectedPackages, ", ")}{versionMessage}`)

  if fs.isDir(`{cwd}/dist`) then
    print("Deleting dist folder")
    assertion(pcall(fs.removeDir, `{cwd}/dist`))
  end

  print(`Generating bundle sourcemap`)
  spawnCommand("rojo", "sourcemap", `{cwd}/default.project.json`, "-o", `{cwd}/sourcemap.json`)

  local bundle = roblox.Instance.new("Folder")
  bundle.Name = "bundle"

  local darkluaConfig = `{cwd}/{shouldRelease and ".darklua.json" or ".darklua-dev.json"}`
  fs.writeDir(`{cwd}/dist`)
  for _, package in ipairs(selectedPackages) do
    if fs.isDir(`{cwd}/dist/{package}`) then
      continue
    end

    print(`Processing {package}`)
    fs.writeDir(`{cwd}/packages/{package}`)
    spawnCommand(
      "darklua",
      "process",
      `{cwd}/packages/{package}/lib`,
      `{cwd}/dist/{package}/lib`,
      "-c",
      darkluaConfig,
      "-v"
    )

    print(`=> Reformatting {package} because Darklua does weird things`)
    spawnCommand("stylua", `{cwd}/dist/{package}`)

    print(`=> Writing default.project.json for {package}`)
    local project = table.clone(PROJECT_FILE)
    project.name = package
    fs.writeFile(`{cwd}/dist/{package}/default.project.json`, serde.encode("json", project))

    if fs.isFile(`{cwd}/packages/{package}/lib/index.d.ts`) then
      print(`=> Copying index.d.ts for {package}`)
      fs.copy(`{cwd}/packages/{package}/lib/index.d.ts`, `{cwd}/dist/{package}/lib/index.d.ts`)
    end

    print(`=> Writing version for init.luau exports`)
    fs.writeFile(
      `{cwd}/dist/{package}/lib/init.luau`,
      (fs.readFile(`{cwd}/dist/{package}/lib/init.luau`):gsub("VERSION", version or "0.0.0-dev"))
    )

    if shouldRelease then
      local packageConfig: Config = serde.decode("toml", fs.readFile(`{cwd}/packages/{package}/config.toml`))
      local wallyScope = `{WALLY_SCOPE}/{packageConfig.config.name}`

      print("=> Preparing wally.toml")
      local wally = table.clone(WALLY_PACKAGE)
      wally.package.name = wallyScope
      wally.package.description = packageConfig.config.description
      wally.package.version = version

      print("=> Preparing package.json")
      local npm = table.clone(NPM_PACKAGE)
      npm.name = `@{NPM_SCOPE}/{packageConfig.config.name}`
      npm.description = packageConfig.config.description
      npm.version = version

      print("=> Preparing pesde.yaml")
      local pesde = table.clone(PESDE_PACKAGE)
      pesde.name = (`{PESDE_SCOPE}/{packageConfig.config.name}`):gsub("-", "_")
      pesde.description = packageConfig.config.description
      pesde.version = version

      print("=> Preparing dependencies")
      local dependencies = packageConfig.config.dependencies
      if dependencies then
        local wallyDependencies = {}
        local npmDependencies = {}
        local pesdeDependencies = {}

        for _, dependency in ipairs(dependencies) do
          print(`  => Writing dependency {dependency}`)
          wallyDependencies[dependency] = `{WALLY_SCOPE}/{dependency}@{version}`
          npmDependencies[`@{NPM_SCOPE}/{dependency}`] = version
          pesdeDependencies[dependency] = {
            name = (`{WALLY_SCOPE}/{dependency}`):gsub("-", "_"),
            version = version,
          }
        end

        wally.package.dependencies = wallyDependencies
        npm.dependencies = npmDependencies
        pesde.dependencies = pesdeDependencies
      end

      print("=> Writing wally.toml")
      fs.writeFile(`{cwd}/dist/{package}/wally.toml`, serde.encode("toml", wally))
      print("=> Writing package.json")
      fs.writeFile(`{cwd}/dist/{package}/package.json`, serde.encode("json", npm))
      print("=> Writing pesde.yaml")
      fs.writeFile(`{cwd}/dist/{package}/pesde.yaml`, serde.encode("yaml", pesde))
      print("=> Copying LICENSE.md")
      fs.copy(`{cwd}/LICENSE.md`, `{cwd}/dist/{package}/LICENSE.md`)

      if fs.isFile(`{cwd}/packages/{package}/README.md`) then
        print(`=> Writing existing README.md`)
        fs.copy(`{cwd}/packages/{package}/README.md`, `{cwd}/dist/{package}/README.md`)
      else
        print(`=> Writing new README.md`)
        local readme = ""
        readme ..= `# {packageConfig.config.display}`
        readme ..= "\n\n"
        readme ..= packageConfig.config.description:gsub("\n[^\n]*$", "")
        readme ..= "\n\n"
        readme ..= `This package is part of [Prvd 'M Wrong.](https://prvdmwrong.github.io/prvdmwrong/latest)`
        fs.writeFile(`{cwd}/dist/{package}/README.md`, readme)
      end

      print("=> Publishing to wally")
      spawnCommand("wally", "publish", "-v", "--project-path", `{cwd}/dist/{package}`)
      print("=> Publishing to NPM")
      process.spawn("npm", { "publish" }, {
        shell = true,
        cwd = `{cwd}/dist/{package}`,
      })
      print("=> Publishing to pesde")
      process.spawn("pesde", { "publish" }, {
        shell = true,
        cwd = `{cwd}/dist/{package}`,
      })
    end

    if shouldBuildRbxms then
      print("=> Building .rbxm model")

      local rbxmPath = `{cwd}/dist/{package}.rbxm`
      spawnCommand("rojo", "build", `{cwd}/dist/{package}/default.project.json`, "-o", rbxmPath)

      print("=> Adding to bundled .rbxm")
      local instances = roblox.deserializeModel(fs.readFile(rbxmPath))
      for _, instance in ipairs(instances) do
        instance.Parent = bundle
      end
    end
  end

  if shouldBuildRbxms then
    print("Serializing bundled .rbxm")
    fs.writeFile(`{cwd}/dist/bundle.rbxm`, roblox.serializeModel { bundle })
  end

  print("Build finished 🎉")
end
