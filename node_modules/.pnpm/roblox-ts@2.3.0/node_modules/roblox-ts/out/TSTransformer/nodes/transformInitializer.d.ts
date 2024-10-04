import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function transformInitializer(state: TransformState, id: luau.WritableExpression, initializer: ts.Expression): luau.IfStatement;
