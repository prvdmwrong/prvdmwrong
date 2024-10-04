import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformThrowStatement(state: TransformState, node: ts.ThrowStatement): luau.List<luau.CallStatement>;
