import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function transformStatementList(state: TransformState, parent: ts.Node | undefined, statements: ReadonlyArray<ts.Statement>, exportInfo?: {
    id: luau.AnyIdentifier;
    mapping: Map<ts.Statement, Array<string>>;
}): luau.List<luau.Statement<luau.SyntaxKind>>;
