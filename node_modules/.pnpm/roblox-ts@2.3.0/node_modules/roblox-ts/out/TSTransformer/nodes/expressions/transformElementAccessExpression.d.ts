import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformElementAccessExpressionInner(state: TransformState, node: ts.ElementAccessExpression, expression: luau.Expression, argumentExpression: ts.Expression): luau.None | luau.ComputedIndexExpression | luau.ParenthesizedExpression;
export declare function transformElementAccessExpression(state: TransformState, node: ts.ElementAccessExpression): luau.Expression<luau.SyntaxKind>;
