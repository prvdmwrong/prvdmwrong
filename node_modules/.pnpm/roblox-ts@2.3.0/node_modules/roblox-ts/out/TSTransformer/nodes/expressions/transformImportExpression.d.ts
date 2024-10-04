import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../../classes/TransformState";
import ts from "typescript";
export declare function transformImportExpression(state: TransformState, node: ts.CallExpression): luau.None | luau.CallExpression;
