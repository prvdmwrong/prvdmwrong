# Philosophies

!!! warning "Under construction"
    This page is under construction - information may be incomplete or missing.

## Alternatives

Prvd 'M Wrong is not the first Roblox service provider framework. There are several existing
game frameworks for Roblox. Besides Prvd 'M Wrong, you might consider:

- [Knit by sleitnick](https://github.com/Sleitnick/Knit)
- [Flamework by fireboltofdeath](https://github.com/rbxts-flamework)
- [Nevermore by Quenty](https://github.com/Quenty/NevermoreEngine)
- [Proton by sleitnick](https://github.com/Sleitnick/rbxts-proton/)
- [Pronghorn by Iron Stag Games](https://github.com/Iron-Stag-Games/Pronghorn)
- [Lazy Modules by NightLapse Studios](https://github.com/NightLapse-Studios/LazyModules/)
- [Lumin Framework by Lumin Labs](https://github.com/lumin-dev/LuminFramework)

So, why did we make Prvd 'M Wrong?

Each of these frameworks solve the same problem in multiple angles. The goal of
Prvd 'M Wrong is to take all of the lessons and ideas learned from these projects
and build a framework that can solve this problem for good. In addition, all of
these frameworks have major drawbacks:

- Knit is unmaintained, introduces a hefty level of bloat and has subpar types;
- Flamework requires TypeScript and is tightly coupled with its transformer;
- Nevermore introduces an outrageous level of bloat and also harder to use,
  being geared primarily just for Quenty;
- Proton is under development and requires TypeScript, practically unmaintained;
- Pronghorn does not implement dependency injection, minimal extensibility and
  introduces some bloat;
- Lazy Modules has subpar syntax, somewhat couples code;
- Lumin Framework has a controller API that is inspired by Prvd 'M Wrong, to
  which Prvd 'M Wrong excels it's implementation, and Lumin only features a
  rudimentary dependency injection API.

Finally:

- We think a framework should be distributed as a single module, for decoupling
  and extensibility.
- We think a framework should be designed for both Luau and TypeScript, e.g.
  Luau and TypeScript providers can be used simultaneously.
- We think the conventions promoted by other frameworks (e.g. splitting between
  services and controllers) are sub-optimal.
- We have a good enough understanding of the problem to develop something
  robust.
- We think Prvd 'M Wrong should be able to do more than just connect providers.

This is not to say Prvd 'M Wrong is superior, at least not yet:

- Components and networking packages are under development, an external
  networking/component library is required with Prvd 'M Wrong
- We strive to keep Prvd 'M Wrong bug-free, but there are blemishes and
  imperfection, and is not as battle-tested as other frameworks
