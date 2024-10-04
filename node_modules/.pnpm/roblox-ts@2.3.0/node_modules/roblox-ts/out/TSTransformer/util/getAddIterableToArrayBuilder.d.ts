import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
type AddIterableToArrayBuilder = (state: TransformState, expression: luau.Expression, arrayId: luau.AnyIdentifier, lengthId: luau.AnyIdentifier, amtElementsSinceUpdate: number, shouldUpdateLengthId: boolean) => luau.List<luau.Statement>;
export declare function getAddIterableToArrayBuilder(state: TransformState, node: ts.Node, type: ts.Type): AddIterableToArrayBuilder;
export {};
