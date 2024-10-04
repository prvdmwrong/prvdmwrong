import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformObjectAssignmentPattern(state: TransformState, assignmentPattern: ts.ObjectLiteralExpression, parentId: luau.AnyIdentifier): void;
