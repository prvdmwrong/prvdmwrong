-- local function trimmingConcat(strings: { string }, delimiter: string?): string
--   local concat = ""

--   if next(strings) == nil then
--     return concat
--   end

--   if delimiter then
--     local matchDelimiter: string = delimiter .. "$"
--     for index = 1, #strings do
--       concat = concat:gsub(matchDelimiter, "") or concat
--       concat ..= strings[index] .. delimiter
--     end
--   else
--     for index = 1, #strings do
--       concat ..= strings[index]
--     end
--   end

--   return concat
-- end

local function path(...: string): string
  -- return trimmingConcat({ ... }, "/")
  return table.concat({ ... }, "/")
end

return path
