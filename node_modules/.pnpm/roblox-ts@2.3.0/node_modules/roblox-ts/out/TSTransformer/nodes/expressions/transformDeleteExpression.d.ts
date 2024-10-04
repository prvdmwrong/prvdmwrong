import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformDeleteExpression(state: TransformState, node: ts.DeleteExpression): luau.None | luau.FalseLiteral | luau.TrueLiteral;
