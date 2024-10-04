import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformDoStatement(state: TransformState, { expression, statement }: ts.DoStatement): luau.List<luau.RepeatStatement>;
