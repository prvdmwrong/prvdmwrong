import luau from "../LuauAST";
export declare class RenderState {
    private indent;
    seenTempNodes: Map<number, string>;
    private readonly listNodesStack;
    private pushIndent;
    private popIndent;
    private tempIdFallback;
    getTempName(node: luau.TemporaryIdentifier): string;
    pushListNode(listNode: luau.ListNode<luau.Statement>): void;
    peekListNode(): luau.ListNode<luau.Statement> | undefined;
    popListNode(): luau.ListNode<luau.Statement<luau.SyntaxKind>> | undefined;
    newline(text: string): string;
    indented(text: string): string;
    line(text: string, endNode?: luau.Statement): string;
    block<T>(callback: () => T): T;
}
