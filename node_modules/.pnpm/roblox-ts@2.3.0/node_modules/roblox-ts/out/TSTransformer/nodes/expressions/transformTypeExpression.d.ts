import { TransformState } from "../..";
import ts from "typescript";
export declare function transformTypeExpression(state: TransformState, node: ts.AsExpression | ts.NonNullExpression | ts.SatisfiesExpression | ts.TypeAssertion | ts.ExpressionWithTypeArguments): import("@roblox-ts/luau-ast/out/LuauAST/bundle").Expression<import("@roblox-ts/luau-ast/out/LuauAST/bundle").SyntaxKind>;
