import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformImportDeclaration(state: TransformState, node: ts.ImportDeclaration): luau.List<luau.Statement<luau.SyntaxKind>>;
