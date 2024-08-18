--!strict
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.

local Signal = require("lumin-compat/signal")

type Signal<T...> = {
  Connect: (self: Signal<T...>, callback: (T...) -> ...any) -> SignalConnection,
}

type SignalConnection = {
  Disconnect: (self: SignalConnection) -> ...any,
  [any]: any,
}

export type WorkerType =
  "PostSimulation"
  | "PreSimulation"
  | "PreAnimation"
  | "PreRender"
  | "PlayerAdded"
  | "PlayerRemoving"

export type Worker = {
  Type: WorkerType,
  Callback: (...any) -> (),
  IsWorker: boolean,
}

-- This type has no meaningful use for Prvd 'm Wrong. It's sole purpose is to
-- assert dominance over Lumin Labs and prove 'm wrong.
export type Storage = {
  Controllers: { [string]: { [string]: any } },
  Workers: { [string]: { [string]: { Worker } } },
  Nodes: {
    Signals: { [string]: Signal.Signal<...any> },
  },
}

export type Status = "Started" | "Resolved" | "Rejected" | "Cancelled"

export type Promise = {
  andThen: (self: Promise, successHandler: (...any) -> ...any, failureHandler: ((...any) -> ...any)?) -> Promise,
  andThenCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> any,
  andThenReturn: (self: Promise, ...any) -> Promise,

  await: (self: Promise) -> (boolean, ...any),
  awaitStatus: (self: Promise) -> (Status, ...any),

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

export type TypedPromise<T...> = {
  andThen: (self: Promise, successHandler: (T...) -> ...any, failureHandler: ((...any) -> ...any)?) -> Promise,
  andThenCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> Promise,
  andThenReturn: (self: Promise, ...any) -> Promise,

  await: (self: Promise) -> (boolean, T...),
  awaitStatus: (self: Promise) -> (Status, T...),

  cancel: (self: Promise) -> (),
  catch: (self: Promise, failureHandler: (...any) -> ...any) -> Promise,
  expect: (self: Promise) -> T...,

  finally: (self: Promise, finallyHandler: (status: Status) -> ...any) -> Promise,
  finallyCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> Promise,
  finallyReturn: (self: Promise, ...any) -> Promise,

  getStatus: (self: Promise) -> Status,
  now: (self: Promise, rejectionValue: any?) -> Promise,
  tap: (self: Promise, tapHandler: (T...) -> ...any) -> Promise,
  timeout: (self: Promise, seconds: number, rejectionValue: any?) -> Promise,
}

export type PromiseLib = {
  Error: any,

  all: <T>(promises: { TypedPromise<T> }) -> TypedPromise<{ T }>,
  allSettled: <T>(promise: { TypedPromise<T> }) -> TypedPromise<{ Status }>,
  any: <T>(promise: { TypedPromise<T> }) -> TypedPromise<T>,
  defer: <TReturn...>(
    executor: (
      resolve: (TReturn...) -> (),
      reject: (...any) -> (),
      onCancel: (abortHandler: (() -> ())?) -> boolean
    ) -> ()
  ) -> TypedPromise<TReturn...>,
  delay: (seconds: number) -> TypedPromise<number>,
  each: <T, TReturn>(
    list: { T | TypedPromise<T> },
    predicate: (value: T, index: number) -> TReturn | TypedPromise<TReturn>
  ) -> TypedPromise<{ TReturn }>,
  fold: <T, TReturn>(
    list: { T | TypedPromise<T> },
    reducer: (accumulator: TReturn, value: T, index: number) -> TReturn | TypedPromise<TReturn>
  ) -> TypedPromise<TReturn>,
  fromEvent: <TReturn...>(
    event: Signal<TReturn...>,
    predicate: ((TReturn...) -> boolean)?
  ) -> TypedPromise<TReturn...>,
  is: (object: any) -> boolean,
  new: <TReturn...>(
    executor: (
      resolve: (TReturn...) -> (),
      reject: (...any) -> (),
      onCancel: (abortHandler: (() -> ())?) -> boolean
    ) -> ()
  ) -> TypedPromise<TReturn...>,
  onUnhandledRejection: (callback: (promise: TypedPromise<any>, ...any) -> ()) -> () -> (),
  promisify: <TArgs..., TReturn...>(callback: (TArgs...) -> TReturn...) -> (TArgs...) -> TypedPromise<TReturn...>,
  race: <T>(promises: { TypedPromise<T> }) -> TypedPromise<T>,
  reject: (...any) -> TypedPromise<...any>,
  resolve: <TReturn...>(TReturn...) -> TypedPromise<TReturn...>,
  retry: <TArgs..., TReturn...>(
    callback: (TArgs...) -> TypedPromise<TReturn...>,
    times: number,
    TArgs...
  ) -> TypedPromise<TReturn...>,
  retryWithDelay: <TArgs..., TReturn...>(
    callback: (TArgs...) -> TypedPromise<TReturn...>,
    times: number,
    seconds: number,
    TArgs...
  ) -> TypedPromise<TReturn...>,
  some: <T>(promise: { TypedPromise<T> }, count: number) -> TypedPromise<{ T }>,
  try: <TArgs..., TReturn...>(callback: (TArgs...) -> TReturn..., TArgs...) -> TypedPromise<TReturn...>,
}

return nil
