export type Maybe<T> = Some<T> | None
export type Some<T> = { some: true, value: T }
export type None = { some: false, error: string }

local Maybe = {}

function Maybe.some<T>(value: T): Some<T>
  return table.freeze({
    some = true :: true,
    value = value,
  })
end

function Maybe.none(error: string): None
  return table.freeze({
    some = false :: false,
    error = error,
  })
end

table.freeze(Maybe)
return Maybe
