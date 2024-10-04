import { TransformState } from "..";
import ts from "typescript";
export declare function addIndexDiagnostics(state: TransformState, node: ts.PropertyAccessExpression | ts.ElementAccessExpression | ts.SignatureDeclarationBase | ts.PropertyName, expType: ts.Type): void;
