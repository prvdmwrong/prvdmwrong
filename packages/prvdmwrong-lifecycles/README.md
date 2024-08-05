# Oh My Prvd Lifecycles

This package implements a "small" amount of lifecycle events for providers.

We'll admit. We've gotten a bit too lifecycle happy:

- `:onPostSimulation(dt: number)` runs every `RunService.PostSimulation`
- `:onPreSimulation(dt: number)` runs every `RunService.PreSimulation`
- `:onPreRender(dt: number)` runs every `RunService.PreRender`
- `:onPlayerAdded(player: Player)` runs every `Player.PlayerAdded`
- `:onPlayerLeaving(player: Player)` runs every `Player.PlayerLeaving`
- `:onShutdown()` binds to `game:BindToClose` for games and `plugin.Unloading` for plugins
