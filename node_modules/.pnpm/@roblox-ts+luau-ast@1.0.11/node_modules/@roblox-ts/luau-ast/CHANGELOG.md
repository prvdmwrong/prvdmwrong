# 1.0.2
- `luau.List` now verifies the `.value` is a `luau.Node` (#41)
- `luau.NumericForStatement` will now omit rendering the step value if it is equal to 1
- Added support for a `luau.List<luau.Expression>` as the RHS of a `luau.VariableDeclaration` or `luau.Assignment` (#81)
- `luau.Node`, `luau.Expression`, `luua.IndexableExpression`, `luau.Statement`, and `luau.Field` are all now unions of possible node types. `luau.BaseNode`, `luau.BaseExpression`, etc.) have been added.

# 1.0.1
- Added `luau.none()` to represent nodes that shouldn't be rendered (#27)

# 1.0.0

- Initial release, split off from roblox-ts repository
