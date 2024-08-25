--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local Reference = require("prvdmwrong-core/prvd/ref")
local Types = require("prvdmwrong-core/types")
local log = require("prvdmwrong-core/utils/log")

-- FIXME: Darklua can't bundle types as exported types appear in it's bundle
-- definition, inline it directly for now.

export type StartupStatus = "StartupStatus.Pending" | "StartupStatus.Starting" | "StartupStatus.Started"
export type OnInit = { onInit: (self: unknown) -> () }
export type OnStart = { onStart: (self: unknown) -> () }

export type Lifecycle<Interface = { [any]: any }> = {
	listeners: { Interface },
	method: string,

	fire: (self: Lifecycle<Interface>, ...unknown) -> (),
	register: (self: Lifecycle<Interface>, object: Interface) -> (),
	unregister: (self: Lifecycle<Interface>, object: Interface) -> (),
}

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

export type PrvdNamespace = {
	version: string,

	awaitStart: () -> (),
	onStart: (callback: () -> ()) -> (),
	new: <T>(provider: T) -> Provider<T>,
	preload: (instances: { Instance }, predicate: ((ModuleScript) -> boolean)?) -> { unknown },
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
	onLifecycleRegistered: (method: string, handler: ({ [unknown]: unknown }) -> ()) -> (),
	onLifecycleUnregistered: (method: string, handler: ({ [unknown]: unknown }) -> ()) -> (),

	getStartupOptions: () -> Options,
	getStartupStatus: () -> StartupStatus,
	onProviderConstructed: (handler: (Provider<unknown>) -> ()) -> (),
	onProviderUsed: (handler: (Provider<unknown>) -> ()) -> (),

	internal: {
		registerDependency: (dependency: { [unknown]: unknown }) -> (),

		implementAll: (object: { [unknown]: unknown }) -> (),
		implementMethod: (method: string, object: { [unknown]: unknown }) -> (),
		unimplementMethod: (method: string, object: { [unknown]: unknown }) -> (),

		defineMetadata: (object: unknown, key: string, value: unknown) -> (),
		getMetadata: (object: unknown, key: string) -> unknown?,
		deleteMetadata: (object: unknown, key: string) -> (),
	},
}

export type Prvd = typeof(setmetatable(
	{} :: PrvdNamespace,
	{} :: {
		__call: <T>(_: any, provider: T) -> Provider<T>,
	}
))

do
	-- Multiple core Prvd 'M Wrong packages may coexist at runtime, especially if
	-- the developer mixes in other packages. This ensures the first known,
	-- backwards compatible package becomes the dominant and only functioning
	-- module.

	local function parseVersion(version: string)
		local trimmedVersion = version:gsub("^%s+", ""):gsub("%s+$", "")
		local parsedMajor, parsedMinor, parsedPatch, metadata = trimmedVersion:match("^(%d+)%.(%d+)%.(%d+)(.*)$")

		return {
			major = log.expect(tonumber(parsedMajor), "invalidRefVersion", "major version"),
			minor = log.expect(tonumber(parsedMinor), "invalidRefVersion", "minor version"),
			patch = log.expect(tonumber(parsedPatch), "invalidRefVersion", "patch"),
			metadata = metadata,
		}
	end

	local function assertBackwardsCompatible(this: string, other: string)
		local thisVersion, referenceVersion = parseVersion(this), parseVersion(other)
		local isCompatible = thisVersion.major == referenceVersion.major and thisVersion.minor <= referenceVersion.minor

		if isCompatible and thisVersion.metadata and referenceVersion.metadata then
			isCompatible = thisVersion.metadata <= referenceVersion.metadata
		end

		log.expect(isCompatible, "incompatibleVersion", this, other)
	end

	local globalPackage: Types.Prvd? = _G.prvdmwrong

	if globalPackage then
		assertBackwardsCompatible("VERSION", globalPackage.version)
		return globalPackage :: Types.Prvd
	end

	local leadReference = Reference.getReference()
	if leadReference ~= nil and leadReference ~= script then
		local version = leadReference:GetAttribute("version")

		if typeof(version) == "string" then
			assertBackwardsCompatible("VERSION", version)
		end

		return (require)(leadReference) :: Types.Prvd
	else
		local newReference = Reference.createReference(script)
		newReference:SetAttribute("version", "VERSION")
	end
end

local Lifecycles = require("prvdmwrong-core/lifecycles")
local Modding = require("prvdmwrong-core/modding")
local Reflection = require("prvdmwrong-core/modding/reflection")
local preload = require("prvdmwrong-core/prvd/preload")
local providers = require("prvdmwrong-core/prvd/providers")
local prvd = require("prvdmwrong-core/prvd")

local function Prvd(x: Types.PrvdNamespace): Types.Prvd
	return table.freeze(setmetatable(
		x :: any,
		table.freeze {
			__call = function<T>(_, provider: T): Provider<T>
				return providers.new(provider)
			end,
		}
	))
end

return Prvd {
	version = "VERSION",

	-- Providers API
	awaitStart = prvd.awaitStart,
	new = providers.new,
	onStart = prvd.onStart,
	StartupStatus = prvd.StartupStatus,
	start = prvd.start,
	preload = preload,
	use = prvd.use,

	-- Lifecycles API
	Lifecycle = Lifecycles.Lifecycle,
	fireConcurrent = Lifecycles.fireConcurrent,
	fireSequential = Lifecycles.fireSequential,
	onLifecycleRegistered = Lifecycles.onLifecycleRegistered,
	onLifecycleUnregistered = Lifecycles.onLifecycleUnregistered,
	onMethodImplemented = Lifecycles.onMethodImplemented,

	-- Modding API
	getStartupOptions = prvd.getStartupOptions,
	getStartupStatus = prvd.getStartupStatus,
	onProviderConstructed = Modding.onProviderConstructed,
	onProviderUsed = Modding.onProviderUsed,

	-- Internal API
	internal = table.freeze {
		registerDependency = Modding.registerDependency,

		implementAll = Lifecycles.implementAll,
		implementMethod = Lifecycles.implementMethod,
		unimplementMethod = Lifecycles.unimplementMethod,

		defineMetadata = Reflection.defineMetadata,
		getMetadata = Reflection.getMetadata,
		deleteMetadata = Reflection.deleteMetadata,
	},
}
