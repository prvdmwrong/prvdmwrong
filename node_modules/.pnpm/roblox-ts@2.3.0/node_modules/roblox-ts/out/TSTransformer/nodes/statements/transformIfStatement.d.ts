import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformIfStatementInner(state: TransformState, node: ts.IfStatement): luau.IfStatement;
export declare function transformIfStatement(state: TransformState, node: ts.IfStatement): luau.List<luau.IfStatement>;
