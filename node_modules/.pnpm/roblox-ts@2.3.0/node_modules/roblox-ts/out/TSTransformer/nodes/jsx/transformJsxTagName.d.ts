import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformJsxTagName(state: TransformState, tagName: ts.JsxTagNameExpression): luau.Expression<luau.SyntaxKind>;
