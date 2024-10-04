import { LoggableError } from "./LoggableError";
import ts from "typescript";
export declare class DiagnosticError extends LoggableError {
    readonly diagnostics: ReadonlyArray<ts.Diagnostic>;
    constructor(diagnostics: ReadonlyArray<ts.Diagnostic>);
    toString(): string;
}
