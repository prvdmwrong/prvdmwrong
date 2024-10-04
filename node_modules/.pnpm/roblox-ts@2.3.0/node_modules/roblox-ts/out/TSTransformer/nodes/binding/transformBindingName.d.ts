import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformBindingName(state: TransformState, name: ts.BindingName, initializers: luau.List<luau.Statement>): luau.AnyIdentifier;
