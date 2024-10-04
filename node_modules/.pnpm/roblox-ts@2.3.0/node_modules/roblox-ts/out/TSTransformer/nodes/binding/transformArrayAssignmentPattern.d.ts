import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformArrayAssignmentPattern(state: TransformState, assignmentPattern: ts.ArrayLiteralExpression, parentId: luau.AnyIdentifier): void;
