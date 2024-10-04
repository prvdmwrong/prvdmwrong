import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformForStatement(state: TransformState, node: ts.ForStatement): luau.List<luau.Statement>;
