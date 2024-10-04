import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../classes/TransformState";
import ts from "typescript";
export declare function transformLogicalOrCoalescingAssignmentExpression(state: TransformState, node: ts.AssignmentExpression<ts.Token<ts.LogicalOrCoalescingAssignmentOperator>>): luau.WritableExpression;
export declare function transformLogicalOrCoalescingAssignmentExpressionStatement(state: TransformState, node: ts.AssignmentExpression<ts.Token<ts.LogicalOrCoalescingAssignmentOperator>>): luau.List<luau.Statement>;
