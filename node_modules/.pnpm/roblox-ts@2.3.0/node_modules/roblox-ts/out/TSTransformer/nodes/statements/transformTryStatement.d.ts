import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformTryStatement(state: TransformState, node: ts.TryStatement): luau.List<luau.Statement<luau.SyntaxKind>>;
