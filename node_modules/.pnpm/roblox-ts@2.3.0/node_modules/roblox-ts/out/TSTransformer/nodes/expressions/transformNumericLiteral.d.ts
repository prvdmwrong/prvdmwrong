import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformNumericLiteral(state: TransformState, node: ts.NumericLiteral): luau.NumberLiteral;
