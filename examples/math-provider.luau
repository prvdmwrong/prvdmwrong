local prvd = -- Import Prvd 'M Wrong however you'd like!
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MathProvider = {}

function MathProvider:add(a: number, b: number): number
  -- this method is very expensive! takes a lot of time!
  task.wait(5)
  return a + b
end

return prvd(MathProvider)
