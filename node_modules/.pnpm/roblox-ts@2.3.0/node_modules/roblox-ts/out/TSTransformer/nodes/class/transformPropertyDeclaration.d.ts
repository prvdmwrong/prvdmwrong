import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformPropertyDeclaration(state: TransformState, node: ts.PropertyDeclaration, name: luau.AnyIdentifier): luau.List<luau.Statement<luau.SyntaxKind>>;
