local prvd = -- Import Prvd 'M Wrong however you'd like!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Tweak this based on where you placed the MathProvider
local MathProvider = require(script.Parent.MathProvider)

local PointsProvider = {}
type Self = typeof(PointsProvider)
PointsProvider.name = "PointsProvider"
PointsProvider.points = {}
PointsProvider.mathProvider = PointsProvider

function PointsProvider.setDefaultPoints(self: Self, player: Player)
  if self.points[player] ~= nil then
    return
  end
  self.points[player] = 10
end

function PointsProvider.onStart(self: Self)
  Players.PlayerAdded:Connect(function(newPlayer)
    self:setDefaultPoints(newPlayer)
  end)
  for _, existingPlayer in pairs(Players:GetPlayers()) do
    self:setDefaultPoints(existingPlayer)
  end
  Players.PlayerRemoving:Connect(function(player)
    self.points[player] = nil
  end)
end

function PointsProvider.addPoints(self: Self, player: Player, amount: number)
  local currentPoints = self.points[player]
  local newPoints = self.mathProvider.add(currentPoints, amount)
  self.points[player] = newPoints
end

return prvd(PointsProvider)
