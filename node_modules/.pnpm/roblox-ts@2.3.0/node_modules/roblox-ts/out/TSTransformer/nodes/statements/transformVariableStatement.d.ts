import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformVariable(state: TransformState, identifier: ts.Identifier, right?: luau.Expression): luau.PropertyAccessExpression | luau.AnyIdentifier;
export declare function transformVariableDeclaration(state: TransformState, node: ts.VariableDeclaration): luau.List<luau.Statement>;
export declare function isVarDeclaration(node: ts.VariableDeclarationList): boolean;
export declare function transformVariableDeclarationList(state: TransformState, node: ts.VariableDeclarationList): luau.List<luau.Statement>;
export declare function transformVariableStatement(state: TransformState, node: ts.VariableStatement): luau.List<luau.Statement>;
