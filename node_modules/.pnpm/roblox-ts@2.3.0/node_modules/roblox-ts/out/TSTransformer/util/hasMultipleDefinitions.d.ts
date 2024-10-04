import ts from "typescript";
export declare function hasMultipleDefinitions(symbol: ts.Symbol, filter: (declaration: ts.Declaration) => boolean): boolean;
