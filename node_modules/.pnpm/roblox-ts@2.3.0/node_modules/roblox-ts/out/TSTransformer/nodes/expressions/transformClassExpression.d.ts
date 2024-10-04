import { TransformState } from "../..";
import ts from "typescript";
export declare function transformClassExpression(state: TransformState, node: ts.ClassExpression): import("@roblox-ts/luau-ast/out/LuauAST/bundle").Identifier | import("@roblox-ts/luau-ast/out/LuauAST/bundle").TemporaryIdentifier;
