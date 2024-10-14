# Why Prvd 'M Wrong?

There are countless frameworks besides Prvd 'M Wrong that are successful in the
past, including:

- [Knit by sleitnick](https://github.com/Sleitnick/Knit)
- [Flamework by fireboltofdeath](https://github.com/rbxts-flamework)
- [Nevermore by Quenty](https://github.com/Quenty/NevermoreEngine)
- [Lumin Framework by Lumin Labs](https://github.com/luminlabsdev/framework)

So why build Prvd 'M Wrong when other frameworks exist? Because the world today
is not the same when those frameworks are made:

- Luau has significantly improved over the years, with the debut of a new solver
  while other frameworks are devoid of type safety and intellisense, worsening
  the developer experience.
  - Note that there is still an appetite for TypeScript packages, though
    TypeScript should only complement the package.
- Buffer networking has become standard while most frameworks only provide a
  light wrapper around RemoteEvents.
- The Luau ecosystem has significantly grown with plenty of packages to cover
  most needs. However, most frameworks are opinionated and requires specific
  packages and workflows. There is a void left for an unopinionated framework.
- The conventions promoted by other frameworks (e.g. splitting between services
  and controllers) are sub-optimal.

In addition, all of these frameworks have major drawbacks:

- Knit is unmaintained, introduces a hefty level of bloat and has subpar types.
  Prvd 'M Wrong backfills what Knit lacked being dependency resolution and
  complete IntelliSense.
- Flamework requires TypeScript and is tightly coupled with it's
  transformer/compiler. As such, type information is lost during compilation.
- Nevermore is notoriously opinionated being geared just for Quenty, has an
  [absurd amount of packages] most developers do not touch, misuses npm as a Lua
  package manager, and has zero types.
- Lumin Framework features rudimentary controller and lifecycle API ripped from
  Prvd 'M Wrong, to which Prvd 'M Wrong excels it's implementation while Lumin
  Framework only does rudimentary dependency resolution. Lumin Framework also
  does not complement TypeScript.
  - The documentation [lies about Prvd 'M Wrong]. Prvd 'M Wrong sparingly uses
    metatables as useful syntax sugar, and provides APIs because either it is a
    foundational feature or it provides a significant need. Consider Prvd 'M
    Wrong as a small sacrifice for several useful features.
  - Lumin Framework historically had a different API than Prvd 'M Wrong, but
    since version 9 has mirrored Prvd 'M Wrong's provider API. It is not the
    other way around.

[absurd amount of packages]: https://github.com/Quenty/NevermoreEngine/tree/main/src
[lies about Prvd 'M Wrong]: https://luminlabsdev.github.io/framework/guides/philosophy/

In addition to these shifting requirements, there are also opportunities to
improve on the developer experience, performance, and extensibility.

Prvd 'M Wrong was in parts, created to address these new requirements and take
on these opportunities, but also take all of the lessons and ideas learned from
these projects and build a framework that can solve this problem for good:

- Prvd 'M Wrong uses the new Luau type solver for it's strengths, eg. providers
  feature complete type safety.

Prvd 'M Wrong also acknowledges that developers will not migrate from any of the
existing frameworks managers without good reason, it needs to be substantially
better and require virtually no effort to migrate. Prvd 'M Wrong solves this by
providing compatibility modules and migration guides for other frameworks.
