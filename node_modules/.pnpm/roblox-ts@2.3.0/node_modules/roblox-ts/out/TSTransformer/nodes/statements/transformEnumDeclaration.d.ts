import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformEnumDeclaration(state: TransformState, node: ts.EnumDeclaration): luau.List<luau.Statement<luau.SyntaxKind>>;
