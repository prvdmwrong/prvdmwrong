export type StringBuilder = {
  append: (self: StringBuilder, ...string) -> StringBuilder,
  appendLn: (self: StringBuilder, ...string) -> StringBuilder,
  appendStringBuilder: (self: StringBuilder, build: StringBuilder) -> StringBuilder,
  indent: (self: StringBuilder) -> StringBuilder,
  unIndent: (self: StringBuilder) -> StringBuilder,
  build: (self: StringBuilder) -> string,
  ensureSize: (self: StringBuilder, minimumSize: number) -> StringBuilder,
}

local function StringBuilder(initial: string?)
  local stringBuffer = initial and buffer.fromstring(initial) or buffer.create(0)
  local indent = 0

  local self = {} :: StringBuilder

  function self:append(...)
    local text = table.concat({ ... }, " ")
    local offset = buffer.len(stringBuffer)
    self:ensureSize(offset + #text)
    buffer.writestring(stringBuffer, offset, text, #text)
    return self
  end

  function self:appendLn(...)
    local line = ("  "):rep(indent) .. table.concat({ ... }, " ")
    line = line:gsub("\n", "\n" .. ("  "):rep(indent))
    if select("#", ...) == 0 then
      line = ""
    end
    return self:append(line .. "\n")
  end

  function self:appendStringBuilder(build)
    self:append(build:build())
    return self
  end

  function self:build()
    return buffer.tostring(stringBuffer)
  end

  function self:indent()
    indent += 1
    return self
  end

  function self:unIndent()
    if indent > 0 then
      indent -= 1
    end
    return self
  end

  function self:ensureSize(minimumSize: number)
    local bufferSize = buffer.len(stringBuffer)

    if minimumSize <= bufferSize then
      return self
    end

    local newBuffer = buffer.create(minimumSize)
    buffer.copy(newBuffer, 0, stringBuffer, 0, bufferSize)
    stringBuffer = newBuffer
    return self
  end

  return self
end

return StringBuilder
