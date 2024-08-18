# Prvd 'M Wrong Style Guide

TODO: Finish this

This style guide lists the coding conventions used in all Luau and TypeScript
code within the Prvd 'M Wrong monorepo.

It does not claim to be the best style guide, but it optimizes for consistency
rather than perfection, so we can get to work, and we do provide rationale for
many of the design decisions listed below.

This style guide draws from the following:

- [The Roblox Lua style guide](https://roblox.github.io/lua-style-guide/)
- [The LuaRocks style guide](https://github.com/luarocks/lua-style-guide)
- [evaera's Gist on clean code](https://gist.github.com/evaera/fee751d4e228dd262fe1174ba142a719)

## Principles

There's no one right answer to how to format code, but consistency is important,
so we agree to accept this one, somewhat arbitrary standard so we can spend more
time writing code and less time arguing about formatting details in the review.

The Prvd 'M Wrong monorepo needs to be minimal, concise, and understandable. Code
will be edited by several developers. Thus, ease of reading and understanding
code is of great concern. Complexity above basic levels is either justified or
removed.

## Metadata

### Header

```Luau
--!strict
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.
```

## Imports

```Luau
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Log = require("prvdmwrong/log")
local Modding = require("prvdmwrong/modding")
local Types = require("prvdmwrong/types")
local expect = Log.expect
local parseError = Log.parseError
local throw = Log.throw
```

## Typedefs

```Luau
type Options = Types.Options
type Provider<T> = Types.Provider<T>
type StartupStatus = Types.StartupStatus
```

### Diagnostics

- 1XXX for core diagnostics
- 2XXX for `prvdmwrong/net`
- 3XXX for `prvdmwrong/components`
- 4XXX for `prvdmwrong/lifecycles`
- 5XXX for `prvdmwrong/knit-compat`
- 6XXX for `prvdmwrong/lumin-compat`
