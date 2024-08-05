--!nolint LocalShadow

local package = script.Parent
local types = require(package.types)

type Self = types.Builder & {
  _arguments: { types.Typeguard },
  _returns: { types.Typeguard },
  _middleware: { types.Middleware },
  _unreliable: boolean,
}

local Builder = {}

function Builder.remote(...: types.Typeguard): types.Builder
  local self = {
    type = "NetEvent" :: any,
    _arguments = { ... },
    _returns = {},
    _middleware = {},
    _unreliable = false,
  } :: Self

  function self:returns(...)
    local self = self :: Self
    self.type = "NetFunction"
    self._returns = { ... }
    return self
  end

  function self:middleware(...)
    local self = self :: Self
    self._middleware = { ... }
    return self
  end

  function self:unreliable()
    local self = self :: Self
    self._unreliable = true
    return self
  end

  return self
end

table.freeze(Builder)
return Builder
