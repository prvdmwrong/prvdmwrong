import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformPropertyAccessExpressionInner(state: TransformState, node: ts.PropertyAccessExpression, expression: luau.Expression, name: string): luau.None | luau.PropertyAccessExpression;
export declare function transformPropertyAccessExpression(state: TransformState, node: ts.PropertyAccessExpression): luau.Expression<luau.SyntaxKind>;
