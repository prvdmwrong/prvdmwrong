import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformBlock(state: TransformState, node: ts.Block): luau.List<luau.DoStatement>;
