import ts from "typescript";
export declare function isBlockLike(node: ts.Node): node is ts.BlockLike;
export declare function isUnaryAssignmentOperator(operator: ts.SyntaxKind): operator is ts.SyntaxKind.PlusPlusToken | ts.SyntaxKind.MinusMinusToken;
export declare function isTemplateLiteralType(type: ts.Type): type is ts.TemplateLiteralType;
export declare function isNamespace(node: ts.Node): node is ts.ModuleDeclaration;
