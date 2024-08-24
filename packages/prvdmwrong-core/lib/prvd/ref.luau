--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local Reference = {}
Reference.name = "Prvd 'M Wrong Reference"

function Reference.createReference(package: ModuleScript): ObjectValue
  local existingReference = game:FindFirstChild(Reference.name)
  if existingReference then
    existingReference:Destroy()
  end

  local ref = Instance.new("ObjectValue")
  ref.Name = Reference.name
  ref.Value = package
  ref.Parent = game
  return ref
end

function Reference.getReference(): ObjectValue?
  local objectValue = game:FindFirstChild(Reference.name)
  if objectValue and objectValue:IsA("ObjectValue") then
    return objectValue
  end
  return nil
end

table.freeze(Reference)
return Reference
