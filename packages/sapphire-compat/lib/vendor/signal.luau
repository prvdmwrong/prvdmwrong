--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.
-- Vendored from red-blox/Util under MIT terms

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

local class = {}
local CLASS_METATABLE = table.freeze { __index = class }

local function Disconnect<T...>(self: Signal<T...>, Node: SignalNode<T...>)
	if self.Root == Node then
		self.Root = Node.Next
	else
		local current = self.Root

		while current do
			if current.Next == Node then
				current.Next = Node.Next
				break
			end

			current = current.Next
		end
	end
end

function class.Connect<T...>(self: Signal<T...>, Callback: (T...) -> ()): () -> ()
	local Node = {
		Next = self.Root,
		Callback = Callback,
	}

	self.Root = Node

	return function()
		Disconnect(self, Node)
	end
end

function class.Wait<T...>(self: Signal<T...>): T...
	local Thread = coroutine.running()
	local Disconnect

	Disconnect = self:Connect(function(...)
		Disconnect()
		coroutine.resume(Thread, ...)
	end)

	return coroutine.yield()
end

function class.Once<T...>(self: Signal<T...>, Callback: (T...) -> ()): () -> ()
	local Disconnect

	Disconnect = self:Connect(function(...)
		Disconnect()
		Callback(...)
	end)

	return Disconnect
end

function class.Fire<T...>(self: Signal<T...>, ...: T...)
	local current = self.Root

	while current do
		threads.spawn(current.Callback, ...)
		current = current.Next
	end
end

function class.DisconnectAll<T...>(self: Signal<T...>)
	self.Root = nil
end

local function Signal<T...>(): Signal<T...>
	return setmetatable({
		Root = nil,
	}, CLASS_METATABLE) :: any
end

return Signal
