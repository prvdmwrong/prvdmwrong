local fs = require("@lune/fs")
local process = require("@lune/process")
local stdio = require("@lune/stdio")

local NPM = [[{
  "private": true,
  "files": [
    "lib"
  ],
  "devDependencies": {
    "@rbxts/compiler-types": "2.3.0-types.1",
    "@rbxts/types": "^1.0.790",
    "roblox-ts": "^2.3.0",
    "typescript": "^5.5.4"
  }
}]=]

local TSCONFIG = [[{
  "compilerOptions": {
    // required
    "allowSyntheticDefaultImports": true,
    "downlevelIteration": true,
    "jsx": "react",
    "jsxFactory": "Roact.createElement",
    "jsxFragmentFactory": "Roact.createFragment",
    "module": "commonjs",
    "moduleResolution": "Node",
    "noLib": true,
    "resolveJsonModule": true,
    "experimentalDecorators": true,
    "forceConsistentCasingInFileNames": true,
    "moduleDetection": "force",
    "strict": true,
    "target": "ESNext",
    "typeRoots": [
      "node_modules/@rbxts"
    ],
    // configurable
    "rootDir": "lib",
    "outDir": "out",
    "incremental": true,
    "tsBuildInfoFile": "out/tsconfig.tsbuildinfo",
    "declaration": true
  }
}]=]

local BASE_TS = [[/*
  Copyright (c) znotfireman 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
*/]=]

local PROJECT = [[{
  "name": "PACKAGE_NAME",
  "tree": {
    "$path": "lib"
  }
}]=]

local BASE_LUAU = [[--!strict
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.
BASE_LUAU ..= "]=]"

local PRVD_LUAU = BASE_LUAU
  .. [[
type Pack = { [number]: any, n: number }
type Object = { [unknown]: unknown }

type Error = {
  type: "Error",
  raw: string,
  message: string,
  trace: string,
}

export type OnInit = { onInit: (self: unknown) -> () }
export type OnStart = { onStart: (self: unknown) -> () }
export type Lifecycle<Interface = { [any]: any }> = {
  listeners: { Interface },
  method: string,

  fire: (self: Lifecycle<Interface>, ...unknown) -> (),
  register: (self: Lifecycle<Interface>, object: Interface) -> (),
  unregister: (self: Lifecycle<Interface>, object: Interface) -> (),
}

export type StartupStatus = "StartupStatus.Pending" | "StartupStatus.Starting" | "StartupStatus.Started"

export type Options = {
  logLevel: "none" | "verbose",
  profiling: boolean,
}

export type Provider<T> = T & {
  loadOrder: number?,
  name: string?,

  onInit: (self: Provider<T>) -> ()?,
  onStart: (self: Provider<T>) -> ()?,
  [{ __PROVIDER_KEY__: never? }]: Provider<T>,
}

type PrvdNamespace = {
  version: string,

  awaitStart: () -> (),
  onStart: (callback: () -> ()) -> (),
  new: <T>(provider: T) -> Provider<T>,
  preload: (instances: { Instance }, predicate: ((ModuleScript) -> boolean)?) -> { unknown },
  Provider: (options: { loadOrder: number? }?) -> <T>(provider: T) -> (),
  StartupStatus: {
    Pending: "StartupStatus.Pending",
    Starting: "StartupStatus.Starting",
    Started: "StartupStatus.Started",
  },
  start: (options: {
    logLevel: "none" | "verbose" | nil,
    profiling: boolean?,
  }?) -> (),
  use: <T>(provider: Provider<T>) -> T,

  Lifecycle: (method: string, fire: (self: Lifecycle, ...unknown) -> ()) -> Lifecycle,
  fireConcurrent: (self: Lifecycle, ...unknown) -> (),
  fireSequential: (self: Lifecycle, ...unknown) -> (),
  onLifecycleRegistered: (method: string, handler: (Object) -> ()) -> (),
  onLifecycleUnregistered: (method: string, handler: (Object) -> ()) -> (),

  getStartupOptions: () -> Options,
  getStartupStatus: () -> StartupStatus,
  onProviderConstructed: (handler: (Provider<unknown>) -> ()) -> (),
  onProviderUsed: (handler: (Provider<unknown>) -> ()) -> (),

  internal: {
    registerAll: (object: Object) -> (),
    registerMethod: (object: Object, method: string) -> (),
    unregisterMethod: (object: Object, method: string) -> (),

    defineMetadata: (object: unknown, key: string, value: unknown) -> (),
    getMetadata: (object: unknown, key: string) -> unknown?,
    deleteMetadata: (object: unknown, key: string) -> (),

    registerDependency: (identifier: string, dependency: Object) -> (),
  },
}

type Prvd = typeof(setmetatable(
  {} :: PrvdNamespace,
  {} :: {
    __call: <T>(_: any, provider: T) -> Provider<T>,
  }
))

local prvd = _G.prvdmwrong
assert(prvd ~= nil, "cannot find core prvdmwrong package")
return prvd :: Prvd
]=]

local cwd = process.cwd

-- local function getConvertRequire(process: { [number]: any }): {
--   rule: "convert_require",
--   current: {
--     name: "path",
--     sources: { [string]: string },
--   },
--   target: {
--     name: "roblox",
--     rojo_sourcemap: "./sourcemap.json",
--     indexing_style: "property",
--   },
-- }?
--   for _, value in ipairs(process) do
--     if typeof(value) ~= "table" then
--       continue
--     end
--     if value.rule == "convert_require" then
--       return value
--     end
--   end
--   return nil
-- end

local function assertion<T>(condition: T, message: string): T
  if condition then
    return condition
  end
  stdio.ewrite(message)
  return process.exit(1)
end

do
  local existingPackages = fs.readDir(`{cwd}/packages`)
  for index, package in ipairs(existingPackages) do
    if fs.isDir(`{cwd}/packages/{package}`) then
      continue
    end
    table.remove(existingPackages, index)
  end
  table.sort(existingPackages)

  local name = stdio.prompt("text", "Name the package? (e.g. prvdmwrong-lifecycles)")
  assertion(not table.find(existingPackages, name), `{name} already exists as a package`)
  local display = stdio.prompt("text", "Display name? (e.g. Lifecycles for Prvd 'M Wrong)")
  local description =
    stdio.prompt("text", 'Description? (e.g. Implements a "small" amount of lifecycles for Prvd \'M Wrong)')

  local promptedDependencies =
    stdio.prompt("multiselect", "Which dependencies will this package depend on?", existingPackages)
  local dependencies = {}
  for _, index in ipairs(promptedDependencies) do
    table.insert(dependencies, existingPackages[index])
  end

  print(`Creating package {name}`)
  local packageDirectory = `{cwd}/packages/{name}`
  fs.writeDir(packageDirectory)

  print("=> Writing project file")
  fs.writeFile(`{packageDirectory}/default.project.json`, PROJECT:gsub("PACKAGE_NAME", name))

  -- This has to be written by hand for formatting
  print("=> Writing config.toml")
  local config = "[config]"
  config ..= `\n  name = "{display}"`
  config ..= `\n  description = "{description}"`
  if #dependencies > 0 then
    config ..= `\n  dependencies = ["{table.concat(dependencies, '", "')}"]`
  else
    config ..= "\n  dependencies = []"
  end
  fs.writeFile(`{packageDirectory}/config.toml`, config)

  print("=> Writing package.json")
  fs.writeFile(`{packageDirectory}/package.json`, NPM)

  print("=> Writing tsconfig.json")
  fs.writeFile(`{packageDirectory}/tsconfig.json`, TSCONFIG)

  print("=> Writing lib")
  local lib = `{packageDirectory}/lib`
  fs.writeDir(lib)
  fs.writeFile(`{lib}/init.luau`, BASE_LUAU)
  fs.writeFile(`{lib}/index.d.ts`, BASE_TS)
  if table.find(dependencies, "prvdmwrong") then
    fs.writeFile(`{lib}/prvd.luau`, PRVD_LUAU)
  end

  -- Just dont do it
  -- print("=> Updating aliases")
  -- local alias = `packages/{name}/lib`
  -- local darklua = serde.decode("json", fs.readFile(`{cwd}/.darklua.json`))
  -- local darkluaDev = serde.decode("json", fs.readFile(`{cwd}/.darklua-dev.json`))

  -- local baseRequires = getConvertRequire(darklua)
  -- local devRequires = getConvertRequire(darkluaDev)
  -- if baseRequires then
  --   baseRequires[name] = alias
  -- end
  -- if devRequires then
  --   devRequires[name] = alias
  -- end

  -- local vscodeSettings = serde.decode("json", fs.readFile(`{cwd}/.vscode/settings.json`))
  -- vscodeSettings["luau-lsp.require.directoryAliases"][name] = alias
  -- fs.writeFile(`{cwd}/.darklua.json`, serde.encode("json", darklua, true))
  -- fs.writeFile(`{cwd}/.darklua-dev.json`, serde.encode("json", darkluaDev, true))
  -- fs.writeFile(`{cwd}/.vscode/settings.json`, serde.encode("json", vscodeSettings, true))

  print("=> Installing (P)NPM packages")
  process.spawn("pnpm", {
    "install",
  }, {
    shell = true,
    cwd = packageDirectory,
  })

  print("=> Opening VSCode")
  process.spawn("code", {
    `{packageDirectory}/lib/init.luau`,
  }, {
    shell = true,
  })

  print("Creation finished 🎉")
end
