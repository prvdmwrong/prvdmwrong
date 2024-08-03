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

local modding = require(script.mods)
local prvd = require(script.prvd)
local reflect = require(script.reflect)
local types = require(script.types)
local utils = require(script.utils)

export type IgnitionStatus = types.IgnitionStatus
export type Options = types.Options
export type Provider<T> = types.Provider<T>

local prvd: types.Prvd = table.freeze {
  version = "0.2.0-dev.2",

  -- Core API
  awaitStart = prvd.awaitStart,
  new = prvd.new,
  onStart = prvd.onStart,
  StartupStatus = prvd.StartupStatus,
  start = prvd.start,
  use = prvd.use,

  -- Modding API
  getStartupOptions = prvd.getStartupOptions,
  getStartupStatus = prvd.getStartupStatus,
  implementAllMethods = modding.implementAllMethods,
  onMethodImplemented = modding.onMethodImplemented,
  onProviderConstructed = modding.onProviderConstructed,
  onProviderUsed = modding.onProviderUsed,

  -- Reflection API
  defineMetadata = reflect.defineMetadata,
  getMetadata = reflect.getMetadata,
  deleteMetadata = reflect.deleteMetadata,

  -- Utility APIs
  preload = utils.preload,

  -- TypeScript APIs
  Provider = prvd.Provider,
}

return prvd
