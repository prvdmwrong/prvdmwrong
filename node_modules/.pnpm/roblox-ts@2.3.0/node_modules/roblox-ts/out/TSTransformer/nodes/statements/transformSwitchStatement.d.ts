import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformSwitchStatement(state: TransformState, node: ts.SwitchStatement): luau.List<luau.Statement<luau.SyntaxKind>>;
