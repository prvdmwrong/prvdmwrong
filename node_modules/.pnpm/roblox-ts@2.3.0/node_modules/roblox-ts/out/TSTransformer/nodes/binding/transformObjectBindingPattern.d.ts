import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformObjectBindingPattern(state: TransformState, bindingPattern: ts.ObjectBindingPattern, parentId: luau.AnyIdentifier): void;
