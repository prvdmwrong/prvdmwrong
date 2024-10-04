import ts from "typescript";
export declare class MultiTransformState {
    readonly isMethodCache: Map<ts.Symbol, boolean>;
    readonly isDefinedAsLetCache: Map<ts.Symbol, boolean>;
    readonly isReportedByNoAnyCache: Set<ts.Symbol>;
    readonly isReportedByMultipleDefinitionsCache: Set<ts.Symbol>;
    readonly getModuleExportsCache: Map<ts.Symbol, ts.Symbol[]>;
    readonly getModuleExportsAliasMapCache: Map<ts.Symbol, Map<ts.Symbol, string>>;
}
