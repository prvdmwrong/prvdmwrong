import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../classes/TransformState";
import ts from "typescript";
export declare function createBinaryFromOperator(state: TransformState, node: ts.Node, left: luau.Expression, leftType: ts.Type, operatorKind: ts.BinaryOperator, right: luau.Expression, rightType: ts.Type): luau.Expression;
