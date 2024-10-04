import { TransformState } from "..";
import ts from "typescript";
export declare function isMethodFromType(state: TransformState, node: ts.Node, type: ts.Type): boolean;
export declare function isMethod(state: TransformState, node: ts.PropertyAccessExpression | ts.ElementAccessExpression | ts.SignatureDeclarationBase | ts.PropertyName): boolean;
