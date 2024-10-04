import luau from "../LuauAST";
import { RenderState } from "./RenderState";
export declare function render<T extends luau.SyntaxKind>(state: RenderState, node: luau.Node<T>): string;
export declare function renderAST(ast: luau.List<luau.Statement>): string;
