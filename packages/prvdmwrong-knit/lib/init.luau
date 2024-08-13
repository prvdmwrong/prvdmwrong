--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local prvd = require("prvdmwrong-knit/prvd")
local types = require("prvdmwrong-knit/types")

local Knit = {}

local function intoProvider<Singleton>(singleton: Singleton & (types.ControllerDef | types.ServiceDef)): prvd.Provider<Singleton>
  local name = singleton.Name

  local proxy = {}
  proxy.name = name
  proxy.onInit = singleton.KnitInit
  proxy.onStart = singleton.KnitStart
  setmetatable(proxy, {
    __index = singleton,
  })

  prvd.internal.registerDependency(name, proxy :: any)
  return singleton
end

function Knit.CreateService<Singleton>(serviceDef: Singleton & types.ServiceDef): prvd.Provider<Singleton>
  assert(type(serviceDef) == "table", `Service must be a table; got {type(serviceDef)}`)
  assert(type(serviceDef.Name) == "string", `Service.Name must be a string; got {type(serviceDef.Name)}`)
  assert(#serviceDef.Name > 0, "Service.Name must be a non-empty string")
  assert(
    prvd.getStartupStatus() == prvd.StartupStatus.Pending,
    `Services cannot be created after calling "Knit.Start()"`
  )

  warn("use prvd() instead of Knit.CreateService(); prvd 'm wrong can provider superior type safety")
  return intoProvider(serviceDef)
end

table.freeze(Knit)
return Knit
