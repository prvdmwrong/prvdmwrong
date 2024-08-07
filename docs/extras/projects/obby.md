<span class="pmwdoc-examples-icons">
:pmwdoc-luau:{ .pmwdoc-icons-luau }
</span>

# Prvd 'M Wrong Obby

See how Prvd 'M Wrong can be used to build a simple obby, decked with a JToH-esque
client objects provider, a checkpoints provider, a networking provider, and a
debug provider.

![Thumbnail](thumbnail-obby.png)
[:pmwdoc-roblox: Play on Roblox](https://www.roblox.com/games/18703010727/Oh-My-Prvd-Obby){ .md-button }
[:fontawesome-brands-github: Source code on GitHub](https://github.com/znotfireman/prvdmwrong-obby){ .md-button }

---

## Explanation

This game serves as a feature complete example of the core Prvd 'M Wrong package.
It serves as motivation for creating other games using the core package,
utilizing a partially managed Rojo configuration to leverage Roblox Studio as a
visual representation and external editors for code editing.

Some games, for example obbies, might contain lots of different client objects,
e.g. spinners, damage bricks, and jump pads to name a few.

Some of these client objects can be done with basic constraints, e.g. a spinner
can be made with a CylindricalConstraint and some attachments, while a damage
brick would need a remote event to damage the player.

For more complex client objects, it would be ergonomic to use ModuleScripts and
run it with a corresponding client object, which perhaps will have the
CollectionService "Objects" tag and a "Script" string attribute to specify the
ObjectScript to use. Let's call these `ObjectScript`s, which will satisfy this
type:

<!-- why did typescript highlighting work here :skull: -->
```TypeScript
export type ObjectScript = {
  type: "ObjectScript",
  runner: (
    self: ObjectScript,
    object: Instance,
    scope: { unknown }
  ) -> (),
}
```

The `ObjectScript` interface will use a table for future extensions, such as
specifying it's own type guards, or enable some feature flags.

Note the `ObjectScript:runner(object, scope)` method, which receives both the
target object and a scope, which will be cleaned up once the client object
unloads.

Let's create `ObjectProvider`s for the server and the client. During startup,
the server `ObjectProvider` moves objects from the workspace to the
ServerStorage. This then uses the `NetProvider` and connects to the `GetObjects`
remote, using the `PlayerProvider` to validate if a player has client objects.
If not, the `ObjectProvider` sends a clone of the client objects to the player.

The players `ObjectProvider` will wait for the client objects to appear as a
child of the player. Then, every object with the CollectionService tag "Objects"
and a "Script" string attribute gets processed, with a corresponding
`ObjectScript`. It will prepare a runner thread, link the object and its script
to it, and then enables it.

Checkpoints are kept separate from client objects to be tracked by the
`PlayerProvider`s alongside with session info. The `PlayerProvider` tracks all
players and assigns each some `PlayerSession` information, which satisfies this
type:

<!-- it cooked again brooo -->
```TypeScript
export type PlayerSession = {
  checkpoint: number,
  hasObjects: boolean,

  startedAt: number,
  leaderstats: Folder & {
    Stage: IntValue,
    Time: IntValue,
  },
}
```

The `PlayerProvider` increments a player `PlayerSession.checkpoint` once the
player touches the next consecutive checkpoint. This also uses the `NetProvider`
to fire the `NextCheckpoint` event, which is picked up by the players
`GuiProvider` to create some confetti.

The `ObjectsProvider` sets a player `PlayerSession.hasObjects` to true once it
sends the client objects to prevent a player from firing the `GetObjects` event
several times.

Finally, the `PlayerProvider` sets a players `PlayerSession.startedAt` to
`os.clock()` as soon as the player joined, and increments a players
`PlayerSession.leaderstats` until the player reached the final checkpoint.

This game uses some other providers too:

- The `DebugProvider` copies all Tools from its StudioTools folder if the
  current session is running on Roblox Studio. It comes with a Noclip tool to
  help ease playtesting the obby.
- The `GuiProvider` manages the games user interface using Fusion 0.3. Notably,
  this provider tracks the `NextCheckpoint` event to increment a value based on
  the players current checkpoint. It then observes that for firing confetti or
  toggling a win message.
- The `NetProvider` wraps around RemoteEvents and eases using them. It serves as
  a replacement for the planned `prvdmwrong-net` package, which has not been
  released. Other providers will use the `t` package to typecheck remote data.
