import luau from "@roblox-ts/luau-ast";
import ts from "typescript";
export declare function getAssignableValue(operator: luau.AssignmentOperator, value: luau.Expression, valueType: ts.Type): luau.Expression<luau.SyntaxKind>;
