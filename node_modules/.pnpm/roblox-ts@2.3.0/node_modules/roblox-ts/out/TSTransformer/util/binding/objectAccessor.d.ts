import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare const objectAccessor: (state: TransformState, parentId: luau.AnyIdentifier, type: ts.Type, name: ts.PropertyName) => luau.Expression;
