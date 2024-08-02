--!strict
--!nolint LocalShadow

--[[

  Copyright 2024 Team Fireworks

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the “Software”), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so,subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

]]

type CheckableType = LuauTypes | RobloxTypes
export type Typeguard =
  -- literal type strings
  CheckableType
  -- t-style typeguard
  | (unknown) -> (boolean, ...unknown)

export type Middleware = {
  type: "Middleware",
  run: (self: Middleware, NetEvent | NetAsync) -> (Player, ...unknown) -> boolean,
}

export type Builder = {
  type: "NetEvent" | "NetFunction",
  returns: (self: Builder, ...Typeguard) -> Builder,
  middleware: (self: Builder, ...Middleware) -> Builder,
  unreliable: (self: Builder) -> Builder,
}

export type NetEvent<Args... = ...unknown> = ClientToServer<Args...> & ServerToClient<Args...>
export type NetAsync<Args... = ...unknown, Returns... = ...unknown> =
  ClientAsync<Args..., Returns...>
  & ServerAsync<Args..., Returns...>

--[[
  A network event that is called on the client and processed on the server.
]]
export type ClientToServer<Args... = ...unknown> = {
  type: "NetEvent",
  name: string,

  connect: (self: ClientToServer<Args...>, callback: (player: Player, Args...) -> ()) -> RBXScriptConnection,
  disconnectAll: (self: ClientToServer<Args...>) -> (),

  fire: (self: ClientToServer<Args...>, Args...) -> (),
  destroy: (self: ClientToServer<Args...>) -> (),
}

--[[
  A network event that is called on the server and processed on the client.
]]
export type ServerToClient<Args... = ...unknown> = {
  type: "NetEvent",
  name: string,

  connect: (self: ServerToClient<Args...>, callback: (Args...) -> ()) -> RBXScriptConnection,
  destroy: (self: ServerToClient<Args...>) -> (),
  disconnectAll: (self: ServerToClient<Args...>) -> (),

  fire: (self: ServerToClient<Args...>, player: Player, Args...) -> (),
  firePlayers: (self: ServerToClient<Args...>, players: { Player }, Args...) -> (),
  fireAll: (self: ServerToClient<Args...>, Args...) -> (),
}

--[[
  A network function that is processed on the client.

  @deprecated Invoking a client has serious risks as noted by [the Roblox
  documentation.](https://create.roblox.com/docs/scripting/events/remote#server-client-server)
]]
export type ClientAsync<Args... = ...unknown, Returns... = ...unknown> = {
  type: "NetFunction",
  name: string,

  onInvoke: (self: ServerToClient<Args...>, callback: (Args...) -> Returns...) -> (),
  invoke: (self: ServerToClient<Args...>, player: Player, Args...) -> Returns...,
  destroy: (self: ServerToClient<Args...>) -> (),
}

--[[
  A network function that is processed on the server.
]]
export type ServerAsync<Args... = ...unknown, Returns... = ...unknown> = {
  type: "NetFunction",
  name: string,

  onInvoke: (self: ServerToClient<Args...>, callback: (player: Player, Args...) -> Returns...) -> (),
  invoke: (self: ServerToClient<Args...>, Args...) -> Returns...,
  destroy: (self: ServerToClient<Args...>) -> (),
}

export type LuauTypes =
  "any"
  | "boolean"
  | "buffer"
  | "function"
  | "nil"
  | "number"
  | "string"
  | "table"
  | "thread"
  | "unknown"
  | "userdata"

export type RobloxTypes =
  "Axes"
  | "BinaryString"
  | "BrickColor"
  | "CFrame"
  | "CatalogSearchParams"
  | "ClipEvaluator"
  | "Color3"
  | "ColorSequence"
  | "DateTime"
  | "DockWidgetPluginGuiInfo"
  | "Enum"
  | "EnumItem"
  | "Enums"
  | "Faces"
  | "FloatCurveKey"
  | "Font"
  | "Instance"
  | "NumberRange"
  | "NumberSequence"
  | "NumberSequenceKeypoint"
  | "OverlapParams"
  | "Path2DControlPoint"
  | "PathWaypoint"
  | "PhysicalProperties"
  | "Random"
  | "Ray"
  | "RaycastParams"
  | "RaycastResult"
  | "RBXScriptConnection"
  | "RBXScriptSignal"
  | "Rect"
  | "Region3"
  | "Region3int16"
  | "RotationCurveKey"
  | "Secret"
  | "SharedTable"
  | "TweenInfo"
  | "UDim"
  | "UDim2"
  | "Vector2"
  | "Vector2int16"
  | "Vector3"
  | "Vector3int16"

return nil
