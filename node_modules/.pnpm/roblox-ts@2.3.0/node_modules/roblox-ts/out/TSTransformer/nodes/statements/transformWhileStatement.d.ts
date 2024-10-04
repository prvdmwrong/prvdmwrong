import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformWhileStatement(state: TransformState, node: ts.WhileStatement): luau.List<luau.WhileStatement>;
