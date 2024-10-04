import { SourceFileWithTextRange } from "../types";
import ts from "typescript";
export declare function createDiagnosticWithLocation(id: number, messageText: string, category: ts.DiagnosticCategory, node: ts.Node | SourceFileWithTextRange): ts.DiagnosticWithLocation;
