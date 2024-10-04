import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformReturnStatementInner(state: TransformState, returnExp: ts.Expression): luau.List<luau.Statement>;
export declare function transformReturnStatement(state: TransformState, node: ts.ReturnStatement): luau.List<luau.Statement<luau.SyntaxKind>>;
