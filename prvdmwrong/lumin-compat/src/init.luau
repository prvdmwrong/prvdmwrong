-- FIXME: this wont work
local prvd = require("@core")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

export type Controller<T> = T & {
	Start: (() -> ())?,
	Init: (() -> ())?,
	Uses: { any }?,
}

export type Lifecycle<T...> = {
	Fire: (self: Lifecycle<T...>, T...) -> (),
	Name: string,
	Listeners: { (...any) -> () },
}

local LUMIN_LIFECYCLES = {
	PostSimulation = RunService.PostSimulation,
	PreSimulation = RunService.PreSimulation,
	PreRender = RunService.PreRender,
	PreAnimation = RunService.PreAnimation,
	PlayerAdded = Players.PlayerAdded,
	PlayerRemoving = Players.PlayerRemoving,
}

export type LifecycleType = keyof<typeof(LUMIN_LIFECYCLES)>

local lifecycles: { prvd.Lifecycle<...unknown> } = {}

local Lumin = {}
Lumin.version = "9"
Lumin.prvdVersion = _G.PRVDMWRONG_VERSION

local function wrapHandler(
	handler: (self: Lifecycle<...any>, ...any) -> ()
): (lifecycle: prvd.Lifecycle<...unknown>, ...unknown) -> ()
	return function(lifecycle: prvd.Lifecycle<...unknown>, ...: unknown)
		local proxy = {} :: Lifecycle<...any>
		proxy.Fire = lifecycle.fire :: any
		proxy.Name = lifecycle.method
		proxy.Listeners = lifecycle.callbacks

		handler(proxy, ...)
	end :: any
end

function Lumin.Lifecycle(
	name: LifecycleType | string,
	callback: ((self: Lifecycle<...any>, ...any) -> ())?
): Lifecycle<...any>
	local lifecycle = prvd.lifecycle(name, callback and wrapHandler(callback) :: never or prvd.fireConcurrent)
	table.insert(lifecycles, lifecycle)

	local proxy: any = {}
	proxy.Fire = lifecycle.fire
	proxy.Name = name
	proxy.callbacks = lifecycle.callbacks

	return proxy
end

function Lumin.Start(directories: { Instance }, filter: ((ModuleScript) -> boolean)?, callback: () -> ()?)
	local root = prvd.root():useModules(directories, filter)

	local connections: { RBXScriptConnection } = {}
	for _, lifecycle in lifecycles do
		local signal = LUMIN_LIFECYCLES[lifecycle.method] :: RBXScriptSignal
		if signal then
			table.insert(
				connections,
				signal:Connect(function(...)
					lifecycle:fire(...)
				end)
			)
		end
	end

	local function destructor()
		root.onStop:unregister(destructor)
		for _, connection in connections do
			if connection.Connected then
				connection:Disconnect()
			end
		end
	end

	root.onStop:register(destructor)
	root:start()

	if callback then
		callback()
	end
end

function Lumin.New<T>(members: Controller<T>, order: number?): prvd.Provider<T>
	local controller: any = members
	controller.onInit = members.Init
	controller.onStart = members.Start
	controller.loadOrder = order
	return prvd(members)
end

return Lumin
