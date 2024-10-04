local stringer = {}
setmetatable(stringer, {
  __index = string,
})

function stringer.cleanNewlines(str: string): string
  return (str:gsub("\n", " "))
end

function stringer.cleanHtmlTags(str: string): string
  return (str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

return stringer
