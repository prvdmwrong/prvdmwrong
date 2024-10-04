import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformThisExpression(state: TransformState, node: ts.ThisExpression): luau.AnyIdentifier;
