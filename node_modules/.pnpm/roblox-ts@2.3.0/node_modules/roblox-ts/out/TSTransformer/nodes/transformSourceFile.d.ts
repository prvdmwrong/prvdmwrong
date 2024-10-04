import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function transformSourceFile(state: TransformState, node: ts.SourceFile): luau.List<luau.Statement<luau.SyntaxKind>>;
