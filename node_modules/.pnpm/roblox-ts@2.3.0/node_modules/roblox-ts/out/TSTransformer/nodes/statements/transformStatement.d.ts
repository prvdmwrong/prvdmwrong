import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformStatement(state: TransformState, node: ts.Statement): luau.List<luau.Statement>;
