import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformExpression(state: TransformState, node: ts.Expression): luau.Expression;
