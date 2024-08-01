export type Typeguard =
  -- t-style typeguard
  (unknown) -> (boolean, ...unknown)

export type Ok = unknown & { __netOk__: never }
export type Err = unknown & { __netErr__: never, __netReason__: string? }
export type ErrFn = (reason: string) -> Err
export type Middleware = {
  type: "Middleware",
  run: (self: Middleware, Remote) -> (Player, ...unknown) -> Ok | Err,
}

export type Builder = {
  type: "NetEvent" | "NetFunction",
  returns: (self: Builder, ...Typeguard) -> Builder,
  middleware: (self: Builder, ...Middleware) -> Builder,
  unreliable: (self: Builder) -> Builder,
}

export type Remote = any

return table.freeze {}
