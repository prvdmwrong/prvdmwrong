import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function getImportParts(state: TransformState, sourceFile: ts.SourceFile, moduleSpecifier: ts.Expression): luau.Expression<luau.SyntaxKind>[];
export declare function createImportExpression(state: TransformState, sourceFile: ts.SourceFile, moduleSpecifier: ts.Expression): luau.IndexableExpression;
