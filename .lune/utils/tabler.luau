local tabler = {}
setmetatable(tabler, {
  __index = table,
})

function tabler.deepCopy<T>(original: T): T
  local copy: any = original

  if typeof(original) == "table" then
    local newCopy = {}
    for key, value in original :: any do
      newCopy[tabler.deepCopy(key)] = tabler.deepCopy(value)
    end
    copy = newCopy
  end

  return copy
end

return tabler
