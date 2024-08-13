--!strict
local RunService = game:GetService("RunService")
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local prvd = require("knit-compat/prvd")
local types = require("knit-compat/types")

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
  prvd.internal.defineMetadata(singleton, "prvdmwrong:provider", true)
  prvd.internal.defineMetadata(singleton, "prvdmwrong:knitProvider", true)
  return singleton
end

function Knit.CreateService<Singleton>(serviceDef: Singleton & types.ServiceDef): prvd.Provider<Singleton>
  assert(RunService:IsServer(), "cannot create services on the client")
  assert(typeof(serviceDef) == "table", `service must be a table; got {type(serviceDef)}`)
  assert(typeof(serviceDef.Name) == "string", `service.Name must be a string; got {type(serviceDef.Name)}`)
  assert(#serviceDef.Name > 0, "service.Name must be a non-empty string")
  assert(
    prvd.getStartupStatus() == prvd.StartupStatus.Pending,
    `services cannot be created after calling "Knit.Start()"`
  )

  warn("[PMW(knitCompat)]: use prvd() instead of Knit.CreateService(); prvd 'm wrong can provider superior type safety")
  return intoProvider(serviceDef)
end

function Knit.CreateController<Singleton>(serviceDef: Singleton & types.ServiceDef): prvd.Provider<Singleton>
  assert(RunService:IsServer(), "cannot create services on the client")
  assert(typeof(serviceDef) == "table", `service must be a table; got {type(serviceDef)}`)
  assert(typeof(serviceDef.Name) == "string", `service.Name must be a string; got {type(serviceDef.Name)}`)
  assert(#serviceDef.Name > 0, "service.Name must be a non-empty string")
  assert(
    prvd.getStartupStatus() == prvd.StartupStatus.Pending,
    `services cannot be created after calling "Knit.Start()"`
  )

  warn("[PMW(knitCompat)]: use prvd() instead of Knit.CreateService(); prvd 'm wrong can provider superior type safety")
  return intoProvider(serviceDef)
end

table.freeze(Knit)
return Knit
