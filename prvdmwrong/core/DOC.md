Core Prvd 'M Wrong functionality including providers, lifecycles, and module
roots along with built-in components and networking libraries.

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
