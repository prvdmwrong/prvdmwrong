--!strict
--!nolint LocalShadow

--[[

  Copyright 2024 Team Fireworks

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the “Software”), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so,subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

]]

local loader = require(script.utils.loader)
local mods = require(script.mods)
local prvd = require(script.prvd)
local reflect = require(script.reflect)

export type IgnitionStatus = prvd.IgnitionStatus
export type Options = prvd.Options
export type Provider<T> = prvd.Provider<T>

type Prvd = {
  version: string,

  awaitStart: () -> (),
  start: (options: {
    logLevel: "none" | "verbose" | nil,
    profiling: boolean?,
  }?) -> (),
  StartupStatus: {
    Pending: "StartupStatus.Pending",
    Starting: "StartupStatus.Starting",
    Startup: "StartupStatus.Started",
  },
  new: <T>(name: string, provider: T) -> Provider<T>,
  onStart: (callback: () -> ()) -> (),
  Provider: <T>(name: string, provider: T) -> Provider<T>,
  use: <T>(provider: Provider<T>) -> T,

  onMethodImplemented: (method: string, handler: (Provider<unknown>) -> ()) -> (),
  onProviderConstructed: (handler: (Provider<unknown>) -> ()) -> (),
  onProviderUsed: (handler: (Provider<unknown>) -> ()) -> (),
  getIgnitionOptions: () -> Options,

  defineMetadata: (object: unknown, key: string, value: unknown) -> (),
  getMetadata: (object: unknown, key: string) -> unknown?,
  deleteMetadata: (object: unknown, key: string, property: string?) -> (),

  loadChildren: (parent: Instance, predicate: ((ModuleScript) -> boolean)?) -> { unknown },
  loadDescendants: (parent: Instance, predicate: ((ModuleScript) -> boolean)?) -> { unknown },
  matchesName: (name: string) -> (ModuleScript) -> boolean,
}

local prvd: Prvd = table.freeze {
  version = "0.2.0-dev.1",

  -- Core API
  awaitStart = prvd.awaitStart,
  new = prvd.Provider,
  onStart = prvd.onStart,
  Provider = prvd.Provider,
  StartupStatus = prvd.StartupStatus,
  start = prvd.start,
  use = prvd.use,

  -- Modding API
  getStartupOptions = prvd.getStartupOptions,
  getStartupStatus = prvd.getStartupStatus,
  implementAllMethods = mods.implementAllMethods,
  onMethodImplemented = mods.onMethodImplemented,
  onProviderConstructed = mods.onProviderConstructed,
  onProviderUsed = mods.onProviderUsed,

  -- Reflection API
  defineMetadata = reflect.defineMetadata,
  getMetadata = reflect.getMetadata,
  deleteMetadata = reflect.deleteMetadata,

  -- Utility APIs
  loadChildren = loader.loadChildren,
  loadDescendants = loader.loadDescendants,
  matchesName = loader.matchesName,
}

return prvd
