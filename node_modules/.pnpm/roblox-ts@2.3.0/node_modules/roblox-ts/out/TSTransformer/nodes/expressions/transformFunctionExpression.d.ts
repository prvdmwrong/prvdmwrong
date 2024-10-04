import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformFunctionExpression(state: TransformState, node: ts.FunctionExpression | ts.ArrowFunction): luau.CallExpression | luau.FunctionExpression;
