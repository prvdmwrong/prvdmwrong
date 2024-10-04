import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformNewExpression(state: TransformState, node: ts.NewExpression): luau.Expression<luau.SyntaxKind>;
