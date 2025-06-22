local logger = require("@self/logger")
local prvd = require("./prvdmwrong")
local runtime = require("./runtime")

local threadpool = runtime.threadpool

export type Provider<T> = {
	Name: string?,
	Uses: { any }?,
	Order: number?,
	Init: (() -> ())?,
	Start: (() -> ())?,
} & T

export type Hook<T...> = {
	Name: string,
	Fire: (self: Hook<T...>, T...) -> (),
	Listeners: { (...any) -> () },
}

local root = prvd.root()

local function hook<T...>(name: string, callback: ((self: Hook<T...>, ...any) -> ())?): Hook<T...>
	logger:warn({ template = logger.migrateToLifecycles })

	local hookCallback = callback
		or function(self: Hook<T...>, ...: any)
			for _, listener in self.Listeners do
				threadpool.spawn(listener, ...)
			end
		end :: never

	local mockHook
	local lifecycle = prvd.lifecycle(name, function(...)
		hookCallback(mockHook, ...)
	end)

	mockHook = table.freeze({
		Name = name,
		Listeners = lifecycle.callbacks,
		Fire = function(self: Hook<T...>, ...)
			lifecycle:fire(...)
		end,
		Unhook = function(self: Hook<T...>)
			lifecycle:destroy()
		end,
	})

	root:useLifecycle(lifecycle)

	return mockHook
end

local function add(dirs: { Instance }, filter: ((ModuleScript) -> boolean)?)
	logger:warn({ template = logger.migrateToRootUseModules })
	for _, dir in dirs do
		for _, module in dir:GetChildren() do
			if not module:IsA("ModuleScript") then
				continue
			end

			if filter and not filter(module) then
				continue
			end

			local provider = (require)(module)
			provider.name = provider.Name
			provider.subdependencies = provider.Uses
			provider.priority = provider.Order
			provider.constructor = provider.Init
			provider.start = provider.Start

			root:useProvider(prvd(provider))
		end
	end
end

local function start()
	logger:warn({ template = logger.migrateToRootStart })
	root:start()
end

return table.freeze({
	Start = start,
	Add = add,
	Hook = hook,
})
