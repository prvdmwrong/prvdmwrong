import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformCallExpressionInner(state: TransformState, node: ts.CallExpression, expression: luau.Expression, nodeArguments: ReadonlyArray<ts.Expression>): luau.Expression<luau.SyntaxKind>;
export declare function transformPropertyCallExpressionInner(state: TransformState, node: ts.CallExpression, expression: ts.PropertyAccessExpression, baseExpression: luau.Expression, name: string, nodeArguments: ReadonlyArray<ts.Expression>): luau.Expression<luau.SyntaxKind>;
export declare function transformElementCallExpressionInner(state: TransformState, node: ts.CallExpression, expression: ts.ElementAccessExpression, baseExpression: luau.Expression, argumentExpression: ts.Expression, nodeArguments: ReadonlyArray<ts.Expression>): luau.Expression<luau.SyntaxKind>;
export declare function transformCallExpression(state: TransformState, node: ts.CallExpression): luau.Expression<luau.SyntaxKind>;
