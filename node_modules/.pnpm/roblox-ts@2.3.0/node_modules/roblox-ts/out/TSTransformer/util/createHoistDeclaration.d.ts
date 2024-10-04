import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function createHoistDeclaration(state: TransformState, statement: ts.Statement | ts.CaseClause): luau.VariableDeclaration | undefined;
