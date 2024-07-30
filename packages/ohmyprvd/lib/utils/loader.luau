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

local package = script.Parent.Parent
local log = require(package.utils.log)
local expect = log.expect
local parseError = log.parseError

local loader = {}

local function loaderImpl(instances: { Instance }, predicate: ((ModuleScript) -> boolean)?)
  local exports: { unknown } = {}
  for _, module in ipairs(instances) do
    if not module:IsA("ModuleScript") then
      continue
    end
    if predicate and not predicate(module) then
      continue
    end
    local ok, result: log.Error = xpcall(require, parseError, module)
    expect(ok, "requireError", result.trace, module:GetFullName(), result.message)
    table.insert(exports, result)
  end
  return exports
end

--[[
  Preload the specified parent by requiring all ModuleScripts within it. An
  optional `predicate` function can be provided to filter modules.
]]
function loader.loadChildren(parent: Instance, predicate: ((ModuleScript) -> boolean)?)
  expect(typeof(parent) == "Instance", "invalidLoadParent")
  return loaderImpl(parent:GetChildren(), predicate)
end

--[[
  Preload the specified parent by requiring all ModuleScripts within it
  recursively. An optional `predicate` function can be provided to filter
  modules.
]]
function loader.loadDescendants(parent: Instance, predicate: ((ModuleScript) -> boolean)?)
  expect(typeof(parent) == "Instance", "invalidLoadParent")
  return loaderImpl(parent:GetDescendants(), predicate)
end

--[[
  Constructs and returns a function that filters ModuleScript if it matches a
  given name. Often paired with `loadChildren` and `loadDescendants` as you will
  frequently filter by name.
]]
function loader.matchesName(name: string): (ModuleScript) -> boolean
  return function(module)
    return module.Name:match(name) ~= nil
  end
end

table.freeze(loader)
return loader
