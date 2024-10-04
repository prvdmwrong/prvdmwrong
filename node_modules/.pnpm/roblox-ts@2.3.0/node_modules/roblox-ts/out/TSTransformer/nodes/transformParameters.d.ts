import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function transformParameters(state: TransformState, node: ts.SignatureDeclarationBase): {
    parameters: luau.List<luau.AnyIdentifier>;
    statements: luau.List<luau.Statement<luau.SyntaxKind>>;
    hasDotDotDot: boolean;
};
