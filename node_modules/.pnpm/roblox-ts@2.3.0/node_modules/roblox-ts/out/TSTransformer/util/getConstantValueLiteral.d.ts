import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function getConstantValueLiteral(state: TransformState, node: ts.EnumMember | ts.PropertyAccessExpression | ts.ElementAccessExpression): luau.Expression<luau.SyntaxKind> | undefined;
