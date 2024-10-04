import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformExpressionStatementInner(state: TransformState, expression: ts.Expression): luau.List<luau.Statement>;
export declare function transformExpressionStatement(state: TransformState, node: ts.ExpressionStatement): luau.List<luau.Statement<luau.SyntaxKind>>;
