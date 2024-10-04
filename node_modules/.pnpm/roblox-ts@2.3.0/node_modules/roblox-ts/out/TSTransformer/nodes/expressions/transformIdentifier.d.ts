import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformIdentifierDefined(state: TransformState, node: ts.Identifier): luau.Identifier | luau.TemporaryIdentifier;
export declare function transformIdentifier(state: TransformState, node: ts.Identifier): luau.Expression<luau.SyntaxKind>;
