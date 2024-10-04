import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformTaggedTemplateExpression(state: TransformState, node: ts.TaggedTemplateExpression): luau.CallExpression;
