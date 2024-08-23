--!strict
-- (c) Prvd 'M Wrong, dual-licensed under Apache 2.0 or MIT terms.

local RunService = game:GetService("RunService")

local log = require("knit-compat/log")
local prvd = require("knit-compat/prvd")
local types = require("knit-compat/types")
local expect = log.expect
local warnDeprecated = log.warnDeprecated

local promise = require("knit-compat/promise") :: types.PromiseLib
local Knit = {}

local function intoProvider<Singleton>(singleton: Singleton & (types.ControllerDef | types.ServiceDef)): prvd.Provider<Singleton>
  local name = singleton.Name

  local proxy = {}
  proxy.name = name
  proxy.onInit = singleton.KnitInit
  proxy.onStart = singleton.KnitStart
  setmetatable(proxy, {
    __index = singleton,
  })

  prvd.internal.registerDependency(name, proxy :: any)
  prvd.internal.defineMetadata(singleton, "prvdmwrong:provider", true)
  prvd.internal.defineMetadata(singleton, "prvdmwrong:knitProvider", true)
  return singleton
end

function Knit.CreateService<Service>(serviceDef: Service & types.ServiceDef): prvd.Provider<Service>
  expect(RunService:IsServer(), "cannot create services on the client")
  expect(typeof(serviceDef) == "table", `service must be a table; got {typeof(serviceDef)}`)
  expect(typeof(serviceDef.Name) == "string", `service.Name must be a string; got {typeof(serviceDef.Name)}`)
  expect(#serviceDef.Name > 0, "service.Name must be a non-empty string")
  expect(
    prvd.getStartupStatus() == prvd.StartupStatus.Pending,
    `services cannot be created after calling "Knit.Start()"`
  )

  warnDeprecated("prvd()", "Knit.CreateService()", "prvd 'm wrong can provide superior type safety")
  return intoProvider(serviceDef)
end

function Knit.CreateController<Controller>(controllerDef: Controller & types.ControllerDef): prvd.Provider<Controller>
  expect(RunService:IsClient(), "cannot create controllers on the server")
  expect(typeof(controllerDef) == "table", `service must be a table; got {typeof(controllerDef)}`)
  expect(typeof(controllerDef.Name) == "string", `service.Name must be a string; got {typeof(controllerDef.Name)}`)
  expect(#controllerDef.Name > 0, "service.Name must be a non-empty string")
  expect(
    prvd.getStartupStatus() == prvd.StartupStatus.Pending,
    `services cannot be created after calling "Knit.Start()"`
  )

  warnDeprecated("prvd()", "Knit.CreateController()", "prvd 'm wrong can provide superior type safety")
  return intoProvider(controllerDef)
end

local function addImpl(modules: { Instance }): { any }
  local addedModules = {}
  for _, module in modules do
    if not module:IsA("ModuleScript") then
      continue
    end
    table.insert(addedModules, require(module) :: any)
  end
  return addedModules
end

function Knit.AddServices(parent: Instance): { types.Service }
  expect(RunService:IsServer(), `cannot add services from the client`)
  expect(prvd.getStartupStatus() == prvd.StartupStatus.Pending, `services cannot be added after calling "Knit.Start()"`)
  warnDeprecated(
    "prvd.preload(parent:GetChildren())",
    "Knit.AddServices()",
    "both instances to load and a predicate function can be specified"
  )
  return addImpl(parent:GetChildren())
end

function Knit.AddServicesDeep(parent: Instance): { types.Service }
  expect(RunService:IsServer(), `cannot add services from the client`)
  expect(prvd.getStartupStatus() == prvd.StartupStatus.Pending, `services cannot be added after calling "Knit.Start()"`)
  warnDeprecated(
    "prvd.preload(parent:GetDescendants())",
    "Knit.AddServicesDeep()",
    "both instances to load and a predicate function can be specified"
  )
  return addImpl(parent:GetDescendants())
end

function Knit.AddControllers(parent: Instance): { types.Service }
  expect(RunService:IsClient(), `cannot add controllers from the server`)
  expect(prvd.getStartupStatus() == prvd.StartupStatus.Pending, `services cannot be added after calling "Knit.Start()"`)
  warnDeprecated(
    "prvd.preload(parent:GetChildren())",
    "Knit.AddControllers()",
    "both instances to load and a predicate function can be specified"
  )
  return addImpl(parent:GetChildren())
end

function Knit.AddControllersDeep(parent: Instance): { types.Service }
  expect(RunService:IsClient(), `cannot add controllers from the server`)
  expect(prvd.getStartupStatus() == prvd.StartupStatus.Pending, `services cannot be added after calling "Knit.Start()"`)
  warnDeprecated(
    "prvd.preload(parent:GetDescendants())",
    "Knit.AddControllersDeep()",
    "both instances to load and a predicate function can be specified"
  )
  return addImpl(parent:GetDescendants())
end

function Knit.Start(_: types.KnitOptions)
  expect(prvd.getStartupStatus() == prvd.StartupStatus.Pending, "attempted to start more than once")
  warnDeprecated(
    "prvd.start()",
    "Knit.Start()",
    "there is no compatibility with knit options and middleware, and that prvd 'm wrong is not promise based"
  )
  local start = promise.promisify(prvd.start)
  return start()
end

function Knit.OnStart(): types.Promise
  warnDeprecated(
    "prvd.onStart()",
    "Knit.OnStart()",
    "note that knit's OnStart is promise based while prvd 'm wrong is callback based. if a script needs prvd 'm wrong to start, use prvd.awaitStart() instead"
  )
  if prvd.getStartupStatus() ~= prvd.StartupStatus.Pending then
    return promise.resolve()
  end
  return promise.new(function(resolve)
    prvd.onStart(function()
      resolve()
    end)
  end)
end

table.freeze(Knit)
return Knit
