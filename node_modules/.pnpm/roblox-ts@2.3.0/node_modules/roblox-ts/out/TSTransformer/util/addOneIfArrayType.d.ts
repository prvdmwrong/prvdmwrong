import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function addOneIfArrayType(state: TransformState, type: ts.Type, expression: luau.Expression): luau.Expression<luau.SyntaxKind>;
