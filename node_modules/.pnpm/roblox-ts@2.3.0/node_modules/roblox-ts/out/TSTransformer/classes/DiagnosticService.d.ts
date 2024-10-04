import ts from "typescript";
export declare class DiagnosticService {
    private static diagnostics;
    private static singleDiagnostics;
    static addSingleDiagnostic(diagnostic: ts.Diagnostic): void;
    static addDiagnostic(diagnostic: ts.Diagnostic): void;
    static addDiagnostics(diagnostics: ReadonlyArray<ts.Diagnostic>): void;
    static addDiagnosticWithCache<T>(cacheBy: T, diagnostic: ts.Diagnostic, cache: Set<T>): void;
    static flush(): ts.Diagnostic[];
    static hasErrors(): boolean;
}
