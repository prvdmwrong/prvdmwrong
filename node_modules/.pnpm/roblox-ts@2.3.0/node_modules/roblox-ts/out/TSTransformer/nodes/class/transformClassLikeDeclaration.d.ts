import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformClassLikeDeclaration(state: TransformState, node: ts.ClassLikeDeclaration): {
    statements: luau.List<luau.Statement<luau.SyntaxKind>>;
    name: luau.Identifier | luau.TemporaryIdentifier;
};
