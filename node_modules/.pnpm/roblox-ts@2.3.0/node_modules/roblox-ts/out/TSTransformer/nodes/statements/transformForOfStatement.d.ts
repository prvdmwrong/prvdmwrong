import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformForOfRangeMacro(state: TransformState, node: ts.ForOfStatement, macroCall: ts.CallExpression): luau.List<luau.Statement>;
export declare function transformForOfStatement(state: TransformState, node: ts.ForOfStatement): luau.List<luau.Statement>;
