import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformObjectLiteralExpression(state: TransformState, node: ts.ObjectLiteralExpression): luau.TemporaryIdentifier | luau.Map;
