--!strict
--#selene: allow(unused_variable)
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.

local prvd = require("lumin-compat/prvd")

local LuminCompat = {}
LuminCompat.Started = false
prvd.onStart(function()
  LuminCompat.Started = true
end)

function LuminCompat.Controller<T>(name: string, members: T & {}): prvd.Provider<T>
  warn("use prvd() instead")
  local proxy = {}
  proxy.name = name
  proxy.onInit = (members :: any).Init
  proxy.onStart = (members :: any).Start
  setmetatable(proxy, {
    __index = members,
  })

  prvd.internal.registerDependency(name, proxy :: any)
  prvd.internal.defineMetadata(proxy, "prvdmwrong:provider", true)
  prvd.internal.defineMetadata(proxy, "prvdmwrong:luminProvider", true)
  return members :: any
end

function LuminCompat.Worker(
  type: "PostSimulation" | "PreSimulation" | "PreAnimation" | "PreRender" | "PlayerAdded" | "PlayerRemoving",
  callback: (...any) -> ()
)
  warn("avoid using Worker, consider importing the `prvdmwrong/lifecycles` package to implement its lifecycles instead")
  assert(prvd.getStartupStatus() == prvd.StartupStatus.Pending)
  error("NOT IMPLEMENTED")
end

function LuminCompat.Signal(name: string?)
  warn("avoid using Signal, consider importing a dedicated signal package instead")
  error("NOT IMPLEMENTED")
end

return LuminCompat
