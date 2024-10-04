import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function expressionMightMutate(state: TransformState, expression: luau.Expression, node?: ts.Expression): boolean;
