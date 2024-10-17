local handlers = require("@core/lifecycles/handlers")
local lifecycles = require("@core/lifecycles/lifecycles")
local providers = require("@core/providers/providers")
local roots = require("@core/providers/roots")
local types = require("@core/types")

export type Lifecycle<Args...> = types.Lifecycle<Args...>
export type Provider<Self> = types.Provider<Self>
export type Root = types.Root
export type RootStatus = types.RootStatus

--[=[
    @class Prvd
    @tag prvdmwrong-root-class

    Prvd 'M Wrong is a Roblox game framework built with modern standards
    delivering type-safe APIs, dependency resolution, and unparalleled DX. Zero
    bloat, plugins, or lock-in required.

    This package contains core Prvd 'M Wrong functionality including providers,
    lifecycles, and game roots along with built-in components and networking.

    ```Luau
    local PlayerProvider = {}
    type Self = typeof(PlayerProvider)

    function PlayerProvider.onInit(self: Self)
        self.playerAdded = prvd.lifecycle("onPlayerAdded", prvd.fireConcurrent)

        local function onPlayerAdded(newPlayer: Player)
            self.playerAdded:fire(newPlayer)
        end

        self.conn = Players.PlayerAdded:Connect(onPlayerAdded)
        for _, existingPlayer in Players:GetPlayers() do
            onPlayerAdded(newPlayer)
        end
    end

    function PlayerProvider.onStop(self: Self)
        self.playerAdded:destroy()
        self.conn:Disconnect()
    end

    return prvd(PlayerProvider)
    ```
]=]
local prvd = {
	version = _G.PRVDMWRONG_VERSION,

	-- Core API
	Provider = providers.Provider :: never,
	prvd = providers.prvd,
	root = roots.root,
	onProviderConstructed = providers.onProviderConstructed,
	onProviderUsed = roots.onProviderUsed,
	onRootConstructed = roots.onRootConstructed,
	onRootStarted = roots.onRootStarted,
	onSubRootUsed = roots.onSubRootUsed,

	-- Lifecycle API
	lifecycle = lifecycles.lifecycle,
	fireConcurrent = handlers.fireConcurrent,
	fireSequential = handlers.fireSequential,
	onLifecycleRegistered = lifecycles.onLifecycleRegistered,
	onLifecycleUnregistered = lifecycles.onLifecycleUnregistered,
	onLifecycleDestroying = lifecycles.onLifecycleDestroying,
	onLifecycleUsed = roots.onLifecycleUsed,

	-- Net API
	netRoot = roots.root(),

	-- Component API
	componentRoot = roots.root(),
}

return table.freeze(setmetatable(
	prvd,
	table.freeze {
		__call = function<Self>(_: unknown, provider: Self): Provider<Self>
			return providers.prvd(provider)
		end,
	}
))
