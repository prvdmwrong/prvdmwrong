import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../classes/TransformState";
import ts from "typescript";
export declare function wrapStatementsAsGenerator(state: TransformState, node: ts.Node, statements: luau.List<luau.Statement>): luau.List<luau.ReturnStatement>;
