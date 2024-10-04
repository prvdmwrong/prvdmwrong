import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformTemplateExpression(state: TransformState, node: ts.TemplateExpression): luau.InterpolatedString;
