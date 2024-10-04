import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformAwaitExpression(state: TransformState, node: ts.AwaitExpression): luau.CallExpression;
