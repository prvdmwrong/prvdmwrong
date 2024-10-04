import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../../classes/TransformState";
import ts from "typescript";
export declare function transformNoSubstitutionTemplateLiteral(state: TransformState, node: ts.NoSubstitutionTemplateLiteral): luau.InterpolatedString;
