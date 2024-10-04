import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
export declare function transformWritableExpression(state: TransformState, node: ts.Expression, readAfterWrite: boolean): luau.WritableExpression;
export declare function transformWritableAssignment(state: TransformState, writeNode: ts.Expression, valueNode: ts.Expression, readAfterWrite?: boolean, readBeforeWrite?: boolean): {
    writable: luau.WritableExpression;
    readable: luau.WritableExpression;
    value: luau.Expression<luau.SyntaxKind>;
};
