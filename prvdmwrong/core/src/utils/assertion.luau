-- FIXME(znotfireman): type functions are EXPLOSIVE
-- type function assert(value)
--   assert(not value:is("nil"), "asserted nil value")
--   assert(not value:is("singleton") or value:value() ~= false, "asserted false boolean")

--   if value:is("union") then
--     local newComponents = {}
--     for _, component in value:components() do
--       if (component:is("singleton") and value:value() == false) or value:is("nil") then
--         continue
--       end
--       table.insert(newComponents, component)
--     end
--     return types.unionof(table.unpack(newComponents))
--   end

--   if value:is("intersection") then
--     for _, component in value:components() do
--       assert(not component:is("nil"), "intersection has nil value")
--       assert(component:is("singleton") and value:value() == false, "intersection has false boolean")
--     end
--   end

--   return value
-- end

local function assertion<T>(value: T, message: string): T --assert<T>
  if not value then
    error(`[Prvd 'M Wrong]: {message}`, 2)
  end
  return value
end

return assertion
