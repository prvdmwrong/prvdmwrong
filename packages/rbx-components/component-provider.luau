local CollectionService = game:GetService("CollectionService")

local componentClasses = require("./component-classes")
local logger = require("./logger")
local providers = require("../providers")
local runtime = require("../runtime")
local types = require("./types")

local threadpool = runtime.threadpool

type Set<T> = { [T]: true }
type ConstructedComponent = types.AnyComponent
type LuauBug = any

local ComponentProvider = {}
ComponentProvider.priority = -math.huge
ComponentProvider.name = "@rbx-components"

function ComponentProvider.constructor(self: ComponentProvider)
	self.componentClasses = {} :: Set<types.AnyComponent>
	self.tagToComponentClasses = {} :: { [string]: Set<types.AnyComponent> }
	self.instanceToComponents = {} :: { [Instance]: { [types.AnyComponent]: ConstructedComponent } }
	self.componentToInstances = {} :: { [types.AnyComponent]: Set<Instance>? }
	self.constructedToClass = {} :: { [ConstructedComponent]: types.AnyComponent? }

	self._destroyingConnections = {} :: { [Instance]: RBXScriptConnection }
	self._connections = {} :: { RBXScriptConnection }
end

function ComponentProvider.start(self: ComponentProvider)
	for tag, components in self.tagToComponentClasses do
		local function onTagAdded(instance)
			local instanceToComponents = self.instanceToComponents[instance]
			if not instanceToComponents then
				instanceToComponents = {}
				self.instanceToComponents[instance] = instanceToComponents
			end

			for componentClass in components do
				if
					(componentClass.blacklistInstances and (componentClass.blacklistInstances :: LuauBug)[instance])
					or (componentClass.whitelistInstances and not (componentClass.whitelistInstances :: LuauBug)[instance])
					or (componentClass.instanceCheck and not componentClass.instanceCheck(instance))
				then
					continue
				end

				local component: ConstructedComponent = instanceToComponents[componentClass]
				if not component then
					component = componentClass.new(instance)
					instanceToComponents[componentClass] = component
					self.constructedToClass[component :: any] = componentClass
				end

				if component.added then
					component:added()
				end
			end

			if not self._destroyingConnections[instance] then
				self._destroyingConnections[instance] = instance.Destroying:Once(function()
					for _, component in instanceToComponents do
						if component.destroy then
							threadpool.spawn(component.destroy, component)
						end
					end
					table.clear(instanceToComponents)
					self.instanceToComponents[instance] = nil
				end)
			end
		end

		table.insert(self._connections, CollectionService:GetInstanceAddedSignal(tag):Connect(onTagAdded))
		table.insert(self._connections, CollectionService:GetInstanceRemovedSignal(tag):Connect(function(instance) end))

		for _, instance in CollectionService:GetTagged(tag) do
			onTagAdded(instance)
		end
	end
end

function ComponentProvider.destroy(self: ComponentProvider)
	for _, components in self.instanceToComponents do
		for _, component in components do
			if component.destroy then
				component:destroy()
			end
		end
		table.clear(components)
	end

	table.clear(self.componentClasses)
	table.clear(self.tagToComponentClasses)
	table.clear(self.instanceToComponents)
	table.clear(self.componentToInstances)
	table.clear(self.constructedToClass)

	for _, connection in self._connections do
		if connection.Connected then
			connection:Disconnect()
		end
	end

	for _, connection in self._destroyingConnections do
		if connection.Connected then
			connection:Disconnect()
		end
	end

	table.clear(self._connections)
	table.clear(self._destroyingConnections)
end

function ComponentProvider.addComponentClass(self: ComponentProvider, class: types.AnyComponent)
	if not componentClasses[class] then
		logger:fatalError({ template = logger.invalidComponent })
	end

	if self.componentClasses[class] then
		logger:fatalError({ template = logger.alreadyRegisteredComponent })
	end

	if class.tag then
		local tagToComponentClasses = self.tagToComponentClasses[class.tag]

		if tagToComponentClasses then
			if not _G.PRVDMWRONG_SUPPRESS_MULTIPLE_SAME_TAG and #tagToComponentClasses > 0 then
				logger:warn({ template = logger.multipleSameTag, class.tag })
			end
		else
			tagToComponentClasses = {}
			self.tagToComponentClasses[class.tag] = tagToComponentClasses
		end

		(tagToComponentClasses :: any)[class] = true
	end

	self.componentClasses[class] = true
	self.componentToInstances[class] = {}
end

function ComponentProvider.getFromInstance<C, I>(
	self: ComponentProvider,
	class: types.Component<C, I>,
	instance: I
): types.Component<C, I>?
	return self.instanceToComponents[instance :: any][class]
end

function ComponentProvider.getAllComponents<C, I>(
	self: ComponentProvider,
	class: types.Component<C, I>
): Set<types.Component<C, I>>
	local result = {}
	for _, components in self.instanceToComponents do
		for _, component in components do
			if self.constructedToClass[component] == class then
				result[component] = true
			end
		end
	end
	return result :: any
end

function ComponentProvider.addComponent<C, I>(
	self: ComponentProvider,
	class: types.Component<C, I>,
	instance: I
): types.Component<C, I>?
	error("not yet implemented")
end

function ComponentProvider.removeComponent<C, I>(self: ComponentProvider, class: types.Component<C, I>, instance: I)
	local constructed = self:getFromInstance(class, instance)
	if constructed then
		self.instanceToComponents[instance :: any][class] = nil

		if constructed.removed then
			threadpool.spawn(constructed.removed :: any, constructed, instance)
		end
	end
end

export type ComponentProvider = typeof(ComponentProvider)
return providers.create(ComponentProvider)
