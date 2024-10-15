local Lifecycles = require("@core/lifecycles")
local Providers = require("@core/providers")

export type Lifecycle<Args...> = Lifecycles.Lifecycle<Args...>
export type Provider<Self> = Providers.Provider<Self>
export type Root = Providers.Root
export type RootStatus = Providers.RootStatus

--[=[
    @class Prvd
    @tag prvdmwrong-package-root

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
            o nPlayerAdded(newPlayer)
        end
    end

    function PlayerProvider.onStop(self: Self)
        self.playerAdded:destroy()
        self.conn:Disconnect()
    end

    return prvd(PlayerProvider)
    ```
]=]
local prvd = table.freeze {
	version = _G.PRVDMWRONG_VERSION,

	-- Core API
	root = Providers.root,
	prvd = Providers.prvd,

	-- Lifecycle API
	lifecycle = Lifecycles.lifecycle,
	fireConcurrent = Lifecycles.fireConcurrent,
	fireSequential = Lifecycles.fireSequential,

	-- Net API
	netRoot = Providers.root(),

	-- Component API
	componentRoot = Providers.root(),
}

setmetatable(prvd, {
	__call = function<Self>(_: unknown, provider: Self): Provider<Self>
		error("not implemented")
	end,
})

return prvd
