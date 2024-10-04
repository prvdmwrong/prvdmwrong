import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function wrapReturnIfLuaTuple(state: TransformState, node: ts.CallExpression, exp: luau.Expression): luau.Expression<luau.SyntaxKind>;
