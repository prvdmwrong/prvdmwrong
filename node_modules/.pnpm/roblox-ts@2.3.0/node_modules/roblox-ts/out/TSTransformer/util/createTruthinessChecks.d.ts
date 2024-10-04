import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function willCreateTruthinessChecks(type: ts.Type): boolean;
export declare function createTruthinessChecks(state: TransformState, exp: luau.Expression, node: ts.Expression): luau.Expression<luau.SyntaxKind>;
