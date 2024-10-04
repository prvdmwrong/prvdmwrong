import luau from "@roblox-ts/luau-ast";
import { TransformState } from "../..";
import ts from "typescript";
export declare function transformExportAssignment(state: TransformState, node: ts.ExportAssignment): luau.List<luau.Statement<luau.SyntaxKind>>;
