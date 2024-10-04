import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformVoidExpression(state: TransformState, node: ts.VoidExpression): luau.NilLiteral;
