import * as luau from "../bundle";
type AllowedFieldTypes = luau.BaseNode | luau.List<luau.BaseNode> | boolean | number | string | undefined;
type FilterProps<T, U> = {
    [K in keyof T]: T[K] extends U ? T[K] : never;
};
type FilteredNodeByKind<T extends keyof luau.NodeByKind> = FilterProps<luau.NodeByKind[T], AllowedFieldTypes>;
export declare function create<T extends keyof luau.NodeByKind>(kind: T, fields: {
    [K in Exclude<keyof FilteredNodeByKind<T>, keyof luau.Node>]: FilteredNodeByKind<T>[K];
}): luau.NodeByKind[T];
export declare function tempId(name?: string): luau.TemporaryIdentifier;
export declare function none(): luau.None;
export declare function nil(): luau.NilLiteral;
export declare function bool(value: boolean): luau.FalseLiteral | luau.TrueLiteral;
export declare function number(value: number): luau.Expression;
export declare function string(value: string): luau.StringLiteral;
export declare function id(name: string): luau.Identifier;
export declare function comment(text: string): luau.Comment;
export declare function array(members?: Array<luau.Expression>): luau.Array;
export declare function set(members?: Array<luau.Expression>): luau.Set;
export declare function map(fields?: Array<[luau.Expression, luau.Expression]>): luau.Map;
export declare function mixedTable(fields?: Array<luau.Expression | [luau.Expression, luau.Expression]>): luau.MixedTable;
export declare function binary(left: luau.Expression, operator: luau.BinaryOperator, right: luau.Expression): luau.BinaryExpression;
export declare function unary(operator: luau.UnaryOperator, expression: luau.Expression): luau.UnaryExpression;
export declare function property(expression: luau.IndexableExpression, name: string): luau.PropertyAccessExpression;
export declare function call(expression: luau.IndexableExpression, args?: Array<luau.Expression>): luau.CallExpression;
export {};
