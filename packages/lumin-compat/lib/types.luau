--!strict
-- (c) Prvd 'M Wrong, dual-licensed under Apache 2.0 or MIT terms.

local Signal = require("lumin-compat/vendor/signal")

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
  Controllers: { any },
  ExpectedControllers: { any },
  Workers: { [string]: { [string]: { Worker } } },
  Nodes: {
    Signals: { [string]: Signal.Signal<...any> },
  },
}

return nil
