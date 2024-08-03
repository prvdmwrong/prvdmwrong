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

export type UnknownProvider = Provider<unknown>

export type Error = {
  type: "Error",
  raw: string,
  message: string,
  trace: string,
}

export type OnInit = { onInit: (self: unknown) -> Promise? }
export type OnStart = { onStart: (self: unknown) -> () }

export type PromiseStatus = "Started" | "Resolved" | "Rejected" | "Cancelled"
export type Promise = {
  andThen: (
    self: Promise,
    successHandler: (...any) -> ...any,
    failureHandler: ((...any) -> ...any)?
  ) -> Promise,
  andThenCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> any,
  andThenReturn: (self: Promise, ...any) -> Promise,

  await: (self: Promise) -> (boolean, ...any),
  awaitStatus: (self: Promise) -> (PromiseStatus, ...any),

  cancel: (self: Promise) -> (),
  catch: (self: Promise, failureHandler: (...any) -> ...any) -> Promise,
  expect: (self: Promise) -> ...any,

  finally: (self: Promise, finallyHandler: (status: Status) -> ...any) -> Promise,
  finallyCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> Promise,
  finallyReturn: (self: Promise, ...any) -> Promise,

  getStatus: (self: Promise) -> Status,
  now: (self: Promise, rejectionValue: any?) -> Promise,
  tap: (self: Promise, tapHandler: (...any) -> ...any) -> Promise,
  timeout: (self: Promise, seconds: number, rejectionValue: any?) -> Promise,
}
export type Pack = { [number]: any, n: number }

export type StartupStatus = "StartupStatus.Pending" | "StartupStatus.Starting" | "StartupStatus.Started"

export type Options = {
  logLevel: "none" | "verbose",
  profiling: boolean,
}

export type Provider<T> = T & {
  loadOrder: number?,

  onInit: (self: Provider<T>) -> ()?,
  onStart: (self: Provider<T>) -> ()?,
}

export type Prvd = {
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
  new: <T>(provider: T) -> Provider<T>,
  onStart: (callback: () -> ()) -> (),
  Provider: <T>(provider: T) -> Provider<T>,
  use: <T>(provider: Provider<T>) -> T,

  onMethodImplemented: (method: string, handler: (Provider<unknown>) -> ()) -> (),
  onProviderConstructed: (handler: (Provider<unknown>) -> ()) -> (),
  onProviderUsed: (handler: (Provider<unknown>) -> ()) -> (),
  getIgnitionOptions: () -> Options,

  defineMetadata: (object: unknown, key: string, value: unknown) -> (),
  getMetadata: (object: unknown, key: string) -> unknown?,
  deleteMetadata: (object: unknown, key: string, property: string?) -> (),

  preload: (parent: Instance, predicate: ((ModuleScript) -> boolean)?) -> { unknown },
}

return nil
