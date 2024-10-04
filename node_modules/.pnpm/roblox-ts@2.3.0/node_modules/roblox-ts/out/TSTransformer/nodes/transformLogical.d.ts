import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function transformLogical(state: TransformState, node: ts.BinaryExpression): luau.Expression;
