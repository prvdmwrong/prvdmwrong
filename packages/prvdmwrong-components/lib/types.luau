--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local prvd = require("@components/prvd")

--[[
  Component types
]]

export type ComponentStreamingMode =
  "ComponentStreamingMode.Disabled"
  | "ComponentStreamingMode.Watching"
  | "ComponentStreamingMode.Contextual"

export type Component<Methods, ExpectedInstance = Instance, Attributes = { [any]: any }> = Methods & {
  tag: string?,
  predicate: ((Instance) -> boolean)?,

  attributes: Attributes,
  attributeGuard: { [string]: Typeguard }?,
  instance: ExpectedInstance,
  instanceGuard: Typeguard?,

  warningTimeout: number?,
  streamingMode: ComponentStreamingMode?,

  ancestorBlacklist: { Instance }?,
  ancestorWhitelist: { Instance }?,
}

export type OnComponentAdded = {
  onComponentAdded: (
    self: prvd.Provider<unknown>,
    Component<unknown, Instance, { [any]: any }>,
    Instance
  ) -> (),
}

export type OnComponentRemoved = {
  onComponentRemoved: (
    self: prvd.Provider<unknown>,
    Component<unknown, Instance, { [any]: any }>,
    Instance
  ) -> (),
}

--[[
  Utility types
]]

export type Typeguard =
  -- literal type string
  LuauTypes
  | RobloxTypes
  -- t-style typechecker
  | (unknown) -> (boolean, ...any?)

type Provider<T> = prvd.Provider<T>

type LuauTypes =
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

type RobloxTypes =
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
