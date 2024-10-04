import ts from "typescript";
export declare function isAncestorOf(ancestor: ts.Node, node: ts.Node): boolean;
export declare function skipDownwards(node: ts.Expression): ts.Expression;
export declare function skipUpwards(node: ts.Node): ts.Node;
export declare function getAncestor<T extends ts.Node>(node: ts.Node, check: (value: ts.Node) => value is T): T | undefined;
export declare function getAncestor(node: ts.Node, check: (value: ts.Node) => boolean): ts.Node | undefined;
export declare function getModuleAncestor(node: ts.Node): ts.SourceFile | ts.ModuleDeclaration;
