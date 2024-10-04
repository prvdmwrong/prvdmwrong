import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformContinueStatement(state: TransformState, node: ts.ContinueStatement): luau.List<luau.Statement<luau.SyntaxKind>>;
