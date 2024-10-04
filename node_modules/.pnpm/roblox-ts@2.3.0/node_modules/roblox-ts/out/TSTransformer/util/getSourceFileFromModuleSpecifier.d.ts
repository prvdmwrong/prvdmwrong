import { TransformState } from "../classes/TransformState";
import ts from "typescript";
export declare function getSourceFileFromModuleSpecifier(state: TransformState, moduleSpecifier: ts.Expression): ts.SourceFile | undefined;
