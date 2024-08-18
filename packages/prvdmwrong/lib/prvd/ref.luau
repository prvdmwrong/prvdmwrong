--!strict
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Reference = {}
Reference.name = "Prvd 'M Wrong Reference"

function Reference.createReference(package: ModuleScript): ObjectValue
  local existingReference = ReplicatedStorage:FindFirstChild(Reference.name)
  if existingReference then
    existingReference:Destroy()
  end

  local ref = Instance.new("ObjectValue")
  ref.Name = Reference.name
  ref.Value = package
  ref.Parent = ReplicatedStorage
  return ref
end

function Reference.getReference(): ObjectValue?
  local objectValue = ReplicatedStorage:FindFirstChild(Reference.name)
  if objectValue and objectValue:IsA("ObjectValue") then
    return objectValue
  end
  return nil
end

return Reference
