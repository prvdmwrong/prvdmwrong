--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local RunService = game:GetService("RunService")

local Promise = require("knit-compat/vendor/promise")
local log = require("knit-compat/utils/log")
local prvd = require("knit-compat/utils/prvd")
local types = require("knit-compat/types")
local expect = log.expect

local alreadyWarned: { [string]: true } = {}
local knit = {}

local function warnDeprecated(replacement: string, deprecated: string, reason: string)
	if alreadyWarned[deprecated] then
		return
	end

	alreadyWarned[deprecated] = true
	log.warn("compatDeprecated", replacement, deprecated, reason)
end

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

function knit.CreateService<Service>(serviceDef: Service & types.ServiceDef): Service
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

function knit.CreateController<Controller>(controllerDef: Controller & types.ControllerDef): Controller
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

function knit.AddServices(parent: Instance): { types.Service }
	expect(RunService:IsServer(), `cannot add services from the client`)
	expect(
		prvd.getStartupStatus() == prvd.StartupStatus.Pending,
		`services cannot be added after calling "Knit.Start()"`
	)
	warnDeprecated(
		"prvd.preload(parent:GetChildren())",
		"Knit.AddServices()",
		"both instances to load and a predicate function can be specified"
	)
	return addImpl(parent:GetChildren())
end

function knit.AddServicesDeep(parent: Instance): { types.Service }
	expect(RunService:IsServer(), `cannot add services from the client`)
	expect(
		prvd.getStartupStatus() == prvd.StartupStatus.Pending,
		`services cannot be added after calling "Knit.Start()"`
	)
	warnDeprecated(
		"prvd.preload(parent:GetDescendants())",
		"Knit.AddServicesDeep()",
		"both instances to load and a predicate function can be specified"
	)
	return addImpl(parent:GetDescendants())
end

function knit.AddControllers(parent: Instance): { types.Service }
	expect(RunService:IsClient(), `cannot add controllers from the server`)
	expect(
		prvd.getStartupStatus() == prvd.StartupStatus.Pending,
		`services cannot be added after calling "Knit.Start()"`
	)
	warnDeprecated(
		"prvd.preload(parent:GetChildren())",
		"Knit.AddControllers()",
		"both instances to load and a predicate function can be specified"
	)
	return addImpl(parent:GetChildren())
end

function knit.AddControllersDeep(parent: Instance): { types.Service }
	expect(RunService:IsClient(), `cannot add controllers from the server`)
	expect(
		prvd.getStartupStatus() == prvd.StartupStatus.Pending,
		`services cannot be added after calling "Knit.Start()"`
	)
	warnDeprecated(
		"prvd.preload(parent:GetDescendants())",
		"Knit.AddControllersDeep()",
		"both instances to load and a predicate function can be specified"
	)
	return addImpl(parent:GetDescendants())
end

function knit.Start(_: types.KnitOptions)
	expect(prvd.getStartupStatus() == prvd.StartupStatus.Pending, "attempted to start more than once")
	warnDeprecated(
		"prvd.start()",
		"Knit.Start()",
		"there is no compatibility with knit options and middleware, and that prvd 'm wrong is not Promise based"
	)
	local start = Promise.promisify(prvd.start)
	return start()
end

function knit.OnStart(): types.Promise
	warnDeprecated(
		"prvd.onStart()",
		"Knit.OnStart()",
		"note that knit's OnStart is Promise based while prvd 'm wrong is callback based. if a script needs prvd 'm wrong to start, use prvd.awaitStart() instead"
	)
	if prvd.getStartupStatus() ~= prvd.StartupStatus.Pending then
		return Promise.resolve()
	end
	return Promise.new(function(resolve)
		prvd.onStart(function()
			resolve()
		end)
	end)
end

table.freeze(knit)
return knit
