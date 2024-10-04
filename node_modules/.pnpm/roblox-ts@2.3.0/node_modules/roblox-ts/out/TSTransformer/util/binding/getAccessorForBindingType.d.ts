import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
type BindingAccessor = (state: TransformState, parentId: luau.AnyIdentifier, index: number, idStack: Array<luau.AnyIdentifier>, isOmitted: boolean) => luau.Expression;
export declare function getAccessorForBindingType(state: TransformState, node: ts.Node, type: ts.Type): BindingAccessor;
export {};
