local ReplicatedStorage = game:GetService("ReplicatedStorage")
local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

local MathProvider = {}

function MathProvider.add(self: typeof(MathProvider), a: number, b: number): number
  -- this method is very expensive!
  task.wait(5)
  return a + b
end

return prvd.Provider("MathProvider", MathProvider)
