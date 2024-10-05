local root = require("core/providers/root")
local types = require("core/types")

export type Lifecycle<Args...> = types.Lifecycle<Args...>
export type Provider<Self> = types.Provider<Self>
export type Root = types.Root
export type RootStatus = types.RootStatus

local function Prvd(namespace: types.PrvdNamespace): types.Prvd
  return table.freeze(setmetatable(
    namespace,
    table.freeze {
      __call = function<Self>(_: unknown, provider: Self): Provider<Self>
        error("not implemented")
      end,
    }
  ) :: any)
end
