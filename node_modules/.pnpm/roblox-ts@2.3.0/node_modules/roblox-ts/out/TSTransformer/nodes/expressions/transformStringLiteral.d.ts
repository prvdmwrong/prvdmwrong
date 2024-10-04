import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformStringLiteral(state: TransformState, node: ts.StringLiteral): luau.StringLiteral;
