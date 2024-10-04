import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformModuleDeclaration(state: TransformState, node: ts.ModuleDeclaration): luau.List<luau.Statement<luau.SyntaxKind>>;
