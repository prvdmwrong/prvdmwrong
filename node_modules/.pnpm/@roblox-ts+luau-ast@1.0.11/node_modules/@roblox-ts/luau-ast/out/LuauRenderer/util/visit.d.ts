import luau from "../../LuauAST";
export interface Visitor {
    before?: (node: luau.Node) => void;
    after?: (node: luau.Node) => void;
}
export declare function visit(ast: luau.List<luau.Node> | luau.Node, visitor: Visitor): void;
