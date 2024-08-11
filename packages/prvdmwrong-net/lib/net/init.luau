local RunService = game:GetService("RunService")

export type Config = {}

local IS_SERVER = RunService:IsServer()

local NetDirection = table.freeze {
  ToClient = "NetDirection.ToClient" :: "NetDirection.ToClient",
  ToServer = "NetDirection.ToServer" :: "NetDirection.ToServer",
  TwoWay = "NetDirection.TwoWay" :: "NetDirection.TwoWay",
}

local net = {}
net.NetDirection = NetDirection

local container: Configuration
if IS_SERVER then
  container = Instance.new("Configuration")
  container.Name = "__container__"
  container.Parent = script
else
  container = script:WaitForChild("__container__")
end

-- selene: allow(unused_variable)
function net.createRemotes<Map>(
  remotes: any,
  config: {
    middleware: { unknown }?,
  }?
)
  error("not implemented")
end

table.freeze(net)
return net
