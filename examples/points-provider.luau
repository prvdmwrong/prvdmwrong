local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MathProvider = require(script.Parent.MathProvider)
local prvd = require(ReplicatedStorage.Packages.ohmyprvd)
local Players = game:GetService("Players")

local PointsProvider = {}
PointsProvider.points = {}
PointsProvider.mathProvider = prvd.use(MathProvider)

function PointsProvider.setDefaultPoints(self: typeof(PointsProvider), player: Player)
  if self.points[player] ~= nil then
    return
  end
  self.points[player] = 10
end

function PointsProvider.start(self: typeof(PointsProvider))
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

function PointsProvider.addPoints(self: typeof(PointsProvider), player: Player, points: number)
  self.points[player] = self.mathProvider:add(self.points[player], points)
end

return prvd.Provider("PointsProvider", PointsProvider)
