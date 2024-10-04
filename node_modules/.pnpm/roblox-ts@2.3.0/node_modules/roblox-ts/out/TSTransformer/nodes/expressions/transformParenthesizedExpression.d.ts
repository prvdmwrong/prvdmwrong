import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformParenthesizedExpression(state: TransformState, node: ts.ParenthesizedExpression): luau.Identifier | luau.TemporaryIdentifier | luau.ParenthesizedExpression | luau.NilLiteral | luau.FalseLiteral | luau.TrueLiteral | luau.NumberLiteral | luau.StringLiteral;
