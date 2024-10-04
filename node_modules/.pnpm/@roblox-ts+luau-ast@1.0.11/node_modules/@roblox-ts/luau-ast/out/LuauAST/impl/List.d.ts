import luau from "..";
export type NoInfer<A extends any> = [A][A extends any ? 0 : never];
declare const LIST_MARKER: unique symbol;
export type ListNode<T extends luau.BaseNode> = {
    prev?: luau.ListNode<T>;
    next?: luau.ListNode<T>;
    value: T;
};
export type List<T extends luau.BaseNode> = {
    [LIST_MARKER]: true;
    head?: luau.ListNode<T>;
    tail?: luau.ListNode<T>;
    readonly: boolean;
};
export declare namespace list {
    function makeNode<T extends luau.Node>(value: T): luau.ListNode<T>;
    function make<T extends luau.Node>(...values: Array<T>): luau.List<T>;
    function isList(value: unknown): value is luau.List<luau.Node>;
    function clone<T extends luau.Node>(list: luau.List<T>): luau.List<T>;
    function push<T extends luau.Node>(list: luau.List<T>, value: NoInfer<T>): void;
    function pushList<T extends luau.Node>(list: luau.List<T>, other: luau.List<T>): void;
    function shift<T extends luau.Node>(list: luau.List<T>): T | undefined;
    function unshift<T extends luau.Node>(list: luau.List<T>, value: NoInfer<T>): void;
    function unshiftList<T extends luau.Node>(list: luau.List<T>, other: luau.List<T>): void;
    function isEmpty<T extends luau.Node>(list: luau.List<T>): boolean;
    function isNonEmpty<T extends luau.Node>(list: luau.List<T>): list is Required<luau.List<T>>;
    function forEach<T extends luau.Node>(list: luau.List<T>, callback: (value: NoInfer<T>) => void): void;
    function forEachListNode<T extends luau.Node>(list: luau.List<T>, callback: (value: luau.ListNode<T>) => void): void;
    function mapToArray<T extends luau.Node, U>(list: luau.List<T>, callback: (value: NoInfer<T>) => U): Array<U>;
    function toArray<T extends luau.Node>(list: luau.List<T>): Array<T>;
    function every<T extends luau.Node>(list: luau.List<T>, callback: (value: NoInfer<T>) => boolean): boolean;
    function some<T extends luau.Node>(list: luau.List<T>, callback: (value: NoInfer<T>) => boolean): boolean;
    function size<T extends luau.Node>(list: luau.List<T>): number;
}
export {};
