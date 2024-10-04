import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformBreakStatement(state: TransformState, node: ts.BreakStatement): luau.List<luau.Statement<luau.SyntaxKind>>;
