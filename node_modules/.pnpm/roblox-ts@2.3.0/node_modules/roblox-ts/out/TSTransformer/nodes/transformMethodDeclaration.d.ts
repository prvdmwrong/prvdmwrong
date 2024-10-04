import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import { Pointer } from "../util/pointer";
import ts from "typescript";
export declare function transformMethodDeclaration(state: TransformState, node: ts.MethodDeclaration, ptr: Pointer<luau.Map | luau.AnyIdentifier>): luau.List<luau.Statement<luau.SyntaxKind>>;
