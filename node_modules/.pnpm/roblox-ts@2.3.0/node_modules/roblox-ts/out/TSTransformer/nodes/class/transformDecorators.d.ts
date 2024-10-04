import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformDecorators(state: TransformState, node: ts.ClassLikeDeclaration, classId: luau.AnyIdentifier): luau.List<luau.Statement>;
