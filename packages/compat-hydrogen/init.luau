local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")

local HydrogenLifecycleRunner = require("@self/lifecycle-runner")
local prvd = require("./prvdmwrong")

local CLIENT_LIFECYCLES = {
	"PlayerAdded",
	"PlayerRemoving",
	"Heartbeat",
	"CharacterAdded",
	"CharacterRemoving",
	"RenderStepped",
	"PostSimulation",
	-- not included in original but whatev
	"PreSimulation",
}

local SERVER_LIFECYCLES = {
	"PlayerAdded",
	"PlayerRemoving",
	"Heartbeat",
	"PostSimulation",
}

local Hydrogen = {
	Server = { ModuleNames = {}, RequiredModules = {} } :: {
		RunLifecycles: boolean | { string } | nil,
		ModuleNames: {},
		RequiredModules: {},
	},
	Client = { ModuleNames = {}, RequiredModules = {} } :: {
		RunLifecycles: boolean | { string } | nil,
		ModuleNames: {},
		RequiredModules: {},
	},
}

Hydrogen.PlayerHandler = nil
Hydrogen.FunctionLib = require("@self/function-lib")
Hydrogen.SoundHandler = nil
Hydrogen.Logging = nil
Hydrogen.Lifecycles = nil

function Hydrogen.GetRuntime(): "Server" | "Client"
	return if RunService:IsServer() then "Server" else "Client"
end

function Hydrogen.Start(Config: {
	ModuleDirectory: Instance?,
	ModuleSuffix: string?,
	RunLifecycles: boolean | { string } | nil,
})
	local runtime = Hydrogen.GetRuntime()

	local root = prvd.root():useProvider(HydrogenLifecycleRunner)

	local modulesRoot = Config.ModuleDirectory
		or if runtime == "Client" then StarterPlayer:WaitForChild("StarterPlayerScripts") else ServerScriptService

	local moduleSuffix = Config.ModuleSuffix or "Handler$"

	for _, module in modulesRoot:GetDescendants() do
		if module.Name:match(moduleSuffix) and module:IsA("ModuleScript") then
			-- if table.find(Hydrogen[Runtime].ModuleNames, Descendant.Name) then
			-- 	error("Hydrogen failed to load " .. Descendant.Name .. " as there is already a module named that loaded!")
			-- end

			-- Hydrogen wrapped this in task.spawn but that made no sense
			local required = (require)(module)
			table.insert(Hydrogen[runtime].ModuleNames, module.Name)
			table.insert(Hydrogen[runtime].RequiredModules, module)

			root:useProvider(prvd(required))
		end
	end

	if Config.RunLifecycles then
		local dnc = Hydrogen[runtime]
		if runtime == "client" then
			dnc.RunLifecycles = CLIENT_LIFECYCLES
		else
			dnc.RunLifecycles = SERVER_LIFECYCLES
		end
	end

	root:start()
end

return Hydrogen
