export type Err = { __prvdErr__: never, __prvdReason__: string? }
export type Middleware = {
  type: "Middleware",
  kind: string,
  validate: (self: Middleware, Player, ...unknown) -> Err?,
}

return nil
