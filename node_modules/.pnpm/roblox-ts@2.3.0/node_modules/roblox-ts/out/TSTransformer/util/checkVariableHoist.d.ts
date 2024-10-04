import { TransformState } from "../classes/TransformState";
import ts from "typescript";
export declare function checkVariableHoist(state: TransformState, node: ts.Identifier, symbol: ts.Symbol): void;
