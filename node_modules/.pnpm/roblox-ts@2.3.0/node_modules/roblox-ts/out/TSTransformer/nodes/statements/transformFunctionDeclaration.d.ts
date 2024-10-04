import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformFunctionDeclaration(state: TransformState, node: ts.FunctionDeclaration): luau.List<luau.Statement<luau.SyntaxKind>>;
