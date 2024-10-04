import luau from "@roblox-ts/luau-ast";
import { TransformState } from "..";
import ts from "typescript";
declare enum OptionalChainItemKind {
    PropertyAccess = 0,
    ElementAccess = 1,
    Call = 2,
    PropertyCall = 3,
    ElementCall = 4
}
interface OptionalChainItem<T extends OptionalChainItemKind, U extends ts.Expression> {
    kind: T;
    node: U;
    optional: boolean;
    type: ts.Type;
}
interface PropertyAccessItem extends OptionalChainItem<OptionalChainItemKind.PropertyAccess, ts.PropertyAccessExpression> {
    name: string;
}
interface ElementAccessItem extends OptionalChainItem<OptionalChainItemKind.ElementAccess, ts.ElementAccessExpression> {
    expression: ts.Expression;
}
interface CallItem extends OptionalChainItem<OptionalChainItemKind.Call, ts.CallExpression> {
    args: ReadonlyArray<ts.Expression>;
}
interface PropertyCallItem extends OptionalChainItem<OptionalChainItemKind.PropertyCall, ts.CallExpression> {
    expression: ts.PropertyAccessExpression;
    name: string;
    callOptional: boolean;
    callType: ts.Type;
    args: ReadonlyArray<ts.Expression>;
}
interface ElementCallItem extends OptionalChainItem<OptionalChainItemKind.ElementCall, ts.CallExpression> {
    expression: ts.ElementAccessExpression;
    argumentExpression: ts.Expression;
    callOptional: boolean;
    callType: ts.Type;
    args: ReadonlyArray<ts.Expression>;
}
type ChainItem = PropertyAccessItem | ElementAccessItem | CallItem | PropertyCallItem | ElementCallItem;
export declare function flattenOptionalChain(state: TransformState, expression: ts.Expression): {
    chain: ChainItem[];
    expression: ts.Expression;
};
export declare function transformOptionalChain(state: TransformState, node: ts.PropertyAccessExpression | ts.ElementAccessExpression | ts.CallExpression): luau.Expression;
export {};
