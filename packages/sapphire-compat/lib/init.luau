--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local Signal = require("sapphire-compat/vendor/signal")
local log = require("sapphire-compat/utils/log")
local prvd = require("sapphire-compat/utils/prvd")
local threads = require("sapphire-compat/utils/threads")

type SignalNode<T...> = {
	Next: SignalNode<T...>?,
	Callback: (T...) -> (),
}

export type Signal<T...> = {
	Root: SignalNode<T...>?,

	Connect: (self: Signal<T...>, Callback: (T...) -> ()) -> () -> (),
	Wait: (self: Signal<T...>) -> T...,
	Once: (self: Signal<T...>, Callback: (T...) -> ()) -> () -> (),
	Fire: (self: Signal<T...>, T...) -> (),
	DisconnectAll: (self: Signal<T...>) -> (),
}

export type singleton = {
	identifier: string?,
	priority: number?,
	init: (() -> ())?,
	start: (() -> ())?,
	[string]: any,
}

export type extension = {
	identifier: string,
	extension: (sapphire: sapphire) -> (),
	methods: { [string]: (singleton: singleton) -> () }?,
	[string]: any,
}

export type sapphire = {
	signals: {
		on_extension_registered: Signal<extension>,
		on_singleton_registered: Signal<singleton>,
		on_singleton_initialized: Signal<singleton>,
		on_singleton_started: Signal<singleton>,
	},

	_singletons: { [string]: singleton },
	_extensions: { [string]: extension },
	_extra_methods: { [string]: (singleton: singleton) -> () },

	use: (self: sapphire, extension: extension) -> sapphire,
	register_singleton: (self: sapphire, mod: ModuleScript) -> sapphire,
	register_singletons: (self: sapphire, container: Folder) -> sapphire,
	start: (self: sapphire) -> (),
}

local function Sapphire(): sapphire
	local alreadyWarned: { [string]: true } = {}

	local function warnDeprecated(replacement: string, deprecated: string, reason: string)
		if alreadyWarned[deprecated] then
			return
		end

		alreadyWarned[deprecated] = true
		log.warn("compatDeprecated", replacement, deprecated, reason)
	end

	local function neverSignal(deprecated: string, closestReplacement: string): Signal<any>
		return setmetatable({} :: any, {
			__index = function()
				log.throw("compatMissing", deprecated, closestReplacement)
			end,
		})
	end

	local self = {
		_singletons = {},
		_extensions = {},
		_extra_methods = {},

		signals = table.freeze {
			on_extension_registered = Signal(),
			on_singleton_registered = Signal(),
			-- FIXME: there is no equivalent API for this
			-- on_singleton_initialized = Signal(),
			-- on_singleton_started = Signal(),
			on_singleton_initialized = neverSignal(
				"on_singleton_initialized",
				"binding a Lifecycle object to the `onInit` method"
			),
			on_singleton_started = neverSignal(
				"on_singleton_started",
				"binding a Lifecycle object to the `onStart` method or call the `onStart` hook"
			),
		},
	} :: sapphire

	prvd.onProviderConstructed(function(provider: any)
		self.signals.on_singleton_registered:Fire(provider)
	end)

	-- FIXME: there is no equivalent API for this
	-- local init = prvd.Lifecycle("onInit", prvd.fireConcurrent)
	-- init:register {
	-- 	onInit = function()
	-- 		self.signals.on_singleton_initialized:Fire()
	-- 	end
	-- }

	function self:use(extension): sapphire
		if self._extensions[extension.identifier] then
			return self
		end

		task.spawn(extension.extension, self)

		for method, registrant in self._extra_methods do
			if not extension[method] then
				continue
			end
			threads.spawn(registrant, extension)
		end

		if extension.methods then
			for method, registrant in extension.methods do
				if self._extra_methods[method] then
					error(
						`[sapphire] Extension {extension.identifier} registers method {method} that is already registered!`
					)
				end

				self._extra_methods[method] = registrant
			end
		end

		self._extensions[extension.identifier] = extension
		self.signals.on_extension_registered:Fire(extension)

		return self
	end

	function self:register_singleton(mod)
		warnDeprecated(
			"just `prvd()` or require all singletons modules to `prvd()` it",
			"`register_singleton()`",
			"`prvd()` registers itself as a Prvd 'M Wrong provider, and the cost of using `prvd()` is minimal. Note that there is no equivalent API in Prvd 'M Wrong, For exact behavior, consider iterating all singleton modules to `prvd()` it"
		)

		if self._singletons[mod.Name] then
			return self
		end

		local singleton: singleton = require(mod) :: any
		singleton.identifier = mod.Name

		if singleton.init then
			assert(typeof(singleton.init) == "function", `Singleton {mod.Name}'s '.init()' is not of type 'function'.`)
		end

		if singleton.start then
			assert(
				typeof(singleton.start) == "function",
				`Singleton {mod.Name}'s '.start()' is not of type 'function'.`
			)
		end

		if singleton.priority then
			assert(
				typeof(singleton.priority) == "number",
				`Singleton {mod.Name}'s '.priority' is not of type 'number'.`
			)
		else
			singleton.priority = 1
		end

		local proxy: any = {}
		proxy.loadOrder = singleton.priority
		proxy.onInit = singleton.init
		proxy.onStart = singleton.start
		-- FIXME: Heartbeat, RenderStepped and Stepped are omitted as it's
		-- deprecated
		proxy.onPreSimulation = singleton.on_pre_simulation
		proxy.onPostSimulation = singleton.on_post_simulation
		proxy.onPreAnimation = singleton.on_pre_animation
		proxy.onPreRender = singleton.on_pre_render
		proxy.onPlayerAdded = singleton.on_player_added
		proxy.onPlayerRemoving = singleton.on_player_removing
		proxy.onShutdown = singleton.on_game_shutdown

		setmetatable(proxy, {
			__index = singleton,
		})

		prvd.internal.registerDependency(mod.Name, proxy :: any)
		prvd.internal.defineMetadata(proxy, "prvdmwrong:provider", true)
		prvd.internal.defineMetadata(proxy, "prvdmwrong:sapphireProvider", true)
		self._singletons[mod.Name] = proxy
		self.signals.on_singleton_registered:Fire(proxy)

		return self
	end

	function self:register_singletons(container)
		warnDeprecated(
			"`preload()`",
			"`register_singletons()`",
			"preload requires all modules, registering all providers as a Prvd 'M Wrong provider"
		)
		for _, child in container:GetChildren() do
			if not child:IsA("ModuleScript") then
				continue
			end

			self:register_singleton(child)
		end

		return self
	end

	function self:start()
		prvd.start()
	end

	return self
end

return Sapphire
