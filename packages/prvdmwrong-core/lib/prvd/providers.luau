--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local HttpService = game:GetService("HttpService")

local Log = require("prvdmwrong-core/utils/log")
local Modding = require("prvdmwrong-core/modding")
local Reflection = require("prvdmwrong-core/modding/reflection")
local Types = require("prvdmwrong-core/types")

local providers = {}
providers.providerKey = newproxy(true)
getmetatable(providers.providerKey).__tostring = function()
	return "[providerKey]"
end

--[=[
  Constructs and returns a new provider within Prvd 'M Wrong. Providers must be
  created before calling `Prvd.start()`.
]=]
function providers.new<T>(provider: T): Types.Provider<T>
	Log.expect(typeof(provider) == "table", "cannotRegister", nil, "provider must be a table")
	Log.expect(not table.isfrozen(provider :: any), "cannotRegister", nil, "provider cannot be frozen")

	local newProvider = provider :: Types.Provider<T>
	Log.expect(
		newProvider.loadOrder == nil or tonumber(newProvider.loadOrder),
		"cannotRegister",
		"`loadOrder` should be a number"
	)
	Log.expect(
		newProvider.name == nil or typeof(newProvider.name == "string"),
		"cannotRegister",
		"`name` should be a string"
	)

	do
		-- This has to be in a do ... end block or else we get ambiguous syntax
		(newProvider :: any)[providers.providerKey] = newProvider
	end

	Reflection.defineMetadata(
		newProvider,
		"identifier",
		newProvider.name or `Provider_{HttpService:GenerateGUID(false)}`
	)
	Reflection.defineMetadata(newProvider, "prvdmwrong:provider", true)
	Reflection.defineMetadata(newProvider, "prvdmwrong:loadOrder", newProvider.loadOrder)

	Modding.registerDependency(newProvider)
	Modding.doProviderConstructed(newProvider)
	return newProvider
end

--[=[
  Returns a decorator for providers. Intended to be used by TypeScript classes,
  where `prvd(provider)` may be unideal as a reserved keyword and subpar syntax.
]=]
function providers.Provider(options: { loadOrder: number? }?)
	local reconciledOptions: { loadOrder: number? } = options or {}
	return function<T>(provider: T)
		Log.expect(typeof(provider) == "table", "cannotRegister", nil, "provider must be a table")
		Log.expect(not table.isfrozen(provider :: any), "cannotRegister", nil, "provider cannot be frozen")

		Log.expect(
			typeof((provider :: any).new) == "function",
			"cannotRegister",
			nil,
			"must use TypeScript decorator on a class"
		)
		Log.expect(
			typeof((provider :: any).__tostring) == "function",
			"cannotRegister",
			nil,
			"must use TypeScript decorator on a class"
		)

		local newProvider = (provider :: any).new()
		local name = newProvider:__tostring()

		Log.expect(typeof(name) == "string", "cannotRegister", nil, "`name` must be a string")
		Log.expect(name:len() > 0, "cannotRegister", nil, "`name` cannot be empty")

		do
			-- This has to be in a do ... end block or else we get ambiguous syntax
			(provider :: any)[providers.providerKey] = newProvider
		end

		Reflection.defineMetadata(newProvider, "identifier", name)
		Reflection.defineMetadata(newProvider, "prvdmwrong:provider", true)
		Reflection.defineMetadata(newProvider, "prvdmwrong:loadOrder", reconciledOptions.loadOrder)

		Modding.registerDependency(newProvider)
		Modding.doProviderConstructed(newProvider)
	end
end

table.freeze(providers)
return providers
