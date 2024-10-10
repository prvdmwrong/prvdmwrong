type WeakMap<K, V> = typeof(setmetatable({} :: { [K]: V }, { __mode = "k" }))

local nicknames = {}
nicknames.nicknames = setmetatable({}, { __mode = "k" }) :: WeakMap<unknown, string>

function nicknames.nameOf(object: unknown, default: string): string
  return nicknames.nicknames[object] or default
end

function nicknames.nameThis(object: unknown, newName: string): string
  nicknames.nicknames[object] = newName
  return newName
end

return nicknames
