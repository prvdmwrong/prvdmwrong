# Oh My Prvd Net

This package implements networking primitives for providers.
TODO: actually implement this pls

wip design inspired by remo

```Lua
local ompnet = require(Wherever.You.Put.This)
local t = require(Wherever.You.Put.That.Mess)

type Remotes = {
  clientToServer: ompnet.ClientToServer<string>,
  netFunction: ompnet.ClientAsync<(string), (number)>,
}

local remotes: Remotes = ompnet.new {
  clientToServer = ompnet.event(t.string),
  netFunction = ompnet.event(t.string):returns(t.number),
  twoWay = ompnet.event(t.string)
}
```

## Prior Work

- [Remo](https://github.com/littensy/remo/)
- [RbxNet](https://rbxnet.australis.dev/)
