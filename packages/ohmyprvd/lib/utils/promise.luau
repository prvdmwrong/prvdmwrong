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

export type PromiseStatus = "Started" | "Resolved" | "Rejected" | "Cancelled"
export type Promise = {
  andThen: (
    self: Promise,
    successHandler: (...any) -> ...any,
    failureHandler: ((...any) -> ...any)?
  ) -> Promise,
  andThenCall: <TArgs...>(
    self: Promise,
    callback: (TArgs...) -> ...any,
    TArgs...
  ) -> any,
  andThenReturn: (self: Promise, ...any) -> Promise,

  await: (self: Promise) -> (boolean, ...any),
  awaitStatus: (self: Promise) -> (PromiseStatus, ...any),

  cancel: (self: Promise) -> (),
  catch: (self: Promise, failureHandler: (...any) -> ...any) -> Promise,
  expect: (self: Promise) -> ...any,

  finally: (
    self: Promise,
    finallyHandler: (status: Status) -> ...any
  ) -> Promise,
  finallyCall: <TArgs...>(
    self: Promise,
    callback: (TArgs...) -> ...any,
    TArgs...
  ) -> Promise,
  finallyReturn: (self: Promise, ...any) -> Promise,

  getStatus: (self: Promise) -> Status,
  now: (self: Promise, rejectionValue: any?) -> Promise,
  tap: (self: Promise, tapHandler: (...any) -> ...any) -> Promise,
  timeout: (self: Promise, seconds: number, rejectionValue: any?) -> Promise,
}

local promise = {}

local function isCallable(value)
  if type(value) == "function" then
    return true
  end

  if type(value) == "table" then
    local metatable = getmetatable(value)
    if metatable and type(rawget(metatable, "__call")) == "function" then
      return true
    end
  end

  return false
end

--[[
  Checks whether the given object is a Promise via duck typing. This only checks
  if the object is a table and has an `andThen` method.
]]
function promise.is(x: unknown): boolean
  if typeof(x) ~= "table" then
    return false
  end

  local x = x :: { [any]: any }

  local metatable = getmetatable(x :: any)
  if metatable == nil then
    return isCallable(x.andThen)
  end

  return type(metatable) == "table"
    and type(rawget(metatable, "__index")) == "table"
    and isCallable(rawget(rawget(metatable, "__index"), "andThen"))
end

table.freeze(promise)
return promise
