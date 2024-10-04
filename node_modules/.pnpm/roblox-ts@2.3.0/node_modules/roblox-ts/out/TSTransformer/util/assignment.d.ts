import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function getSimpleAssignmentOperator(leftType: ts.Type, operatorKind: ts.AssignmentOperator, rightType: ts.Type): luau.AssignmentOperator | undefined;
export declare function createAssignmentExpression(state: TransformState, readable: luau.WritableExpression, operator: luau.AssignmentOperator, value: luau.Expression): luau.WritableExpression;
export declare function createCompoundAssignmentStatement(state: TransformState, node: ts.Node, writable: luau.WritableExpression, writableType: ts.Type, readable: luau.WritableExpression, operator: ts.BinaryOperator, value: luau.Expression, valueType: ts.Type): luau.Assignment;
export declare function createCompoundAssignmentExpression(state: TransformState, node: ts.Node, writable: luau.WritableExpression, writableType: ts.Type, readable: luau.WritableExpression, operator: ts.BinaryOperator, value: luau.Expression, valueType: ts.Type): luau.WritableExpression;
