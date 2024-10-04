"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformStatement = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformBlock_1 = require("./transformBlock");
const transformBreakStatement_1 = require("./transformBreakStatement");
const transformClassDeclaration_1 = require("./transformClassDeclaration");
const transformContinueStatement_1 = require("./transformContinueStatement");
const transformDoStatement_1 = require("./transformDoStatement");
const transformEnumDeclaration_1 = require("./transformEnumDeclaration");
const transformExportAssignment_1 = require("./transformExportAssignment");
const transformExportDeclaration_1 = require("./transformExportDeclaration");
const transformExpressionStatement_1 = require("./transformExpressionStatement");
const transformForOfStatement_1 = require("./transformForOfStatement");
const transformForStatement_1 = require("./transformForStatement");
const transformFunctionDeclaration_1 = require("./transformFunctionDeclaration");
const transformIfStatement_1 = require("./transformIfStatement");
const transformImportDeclaration_1 = require("./transformImportDeclaration");
const transformImportEqualsDeclaration_1 = require("./transformImportEqualsDeclaration");
const transformModuleDeclaration_1 = require("./transformModuleDeclaration");
const transformReturnStatement_1 = require("./transformReturnStatement");
const transformSwitchStatement_1 = require("./transformSwitchStatement");
const transformThrowStatement_1 = require("./transformThrowStatement");
const transformTryStatement_1 = require("./transformTryStatement");
const transformVariableStatement_1 = require("./transformVariableStatement");
const transformWhileStatement_1 = require("./transformWhileStatement");
const getKindName_1 = require("../../util/getKindName");
const typescript_1 = __importDefault(require("typescript"));
const NO_EMIT = () => luau_ast_1.default.list.make();
const DIAGNOSTIC = (factory) => (state, node) => {
    DiagnosticService_1.DiagnosticService.addDiagnostic(factory(node));
    return NO_EMIT();
};
const TRANSFORMER_BY_KIND = new Map([
    [typescript_1.default.SyntaxKind.InterfaceDeclaration, NO_EMIT],
    [typescript_1.default.SyntaxKind.TypeAliasDeclaration, NO_EMIT],
    [typescript_1.default.SyntaxKind.EmptyStatement, NO_EMIT],
    [typescript_1.default.SyntaxKind.ForInStatement, DIAGNOSTIC(diagnostics_1.errors.noForInStatement)],
    [typescript_1.default.SyntaxKind.LabeledStatement, DIAGNOSTIC(diagnostics_1.errors.noLabeledStatement)],
    [typescript_1.default.SyntaxKind.DebuggerStatement, DIAGNOSTIC(diagnostics_1.errors.noDebuggerStatement)],
    [typescript_1.default.SyntaxKind.Block, transformBlock_1.transformBlock],
    [typescript_1.default.SyntaxKind.BreakStatement, transformBreakStatement_1.transformBreakStatement],
    [typescript_1.default.SyntaxKind.ClassDeclaration, transformClassDeclaration_1.transformClassDeclaration],
    [typescript_1.default.SyntaxKind.ContinueStatement, transformContinueStatement_1.transformContinueStatement],
    [typescript_1.default.SyntaxKind.DoStatement, transformDoStatement_1.transformDoStatement],
    [typescript_1.default.SyntaxKind.EnumDeclaration, transformEnumDeclaration_1.transformEnumDeclaration],
    [typescript_1.default.SyntaxKind.ExportAssignment, transformExportAssignment_1.transformExportAssignment],
    [typescript_1.default.SyntaxKind.ExportDeclaration, transformExportDeclaration_1.transformExportDeclaration],
    [typescript_1.default.SyntaxKind.ExpressionStatement, transformExpressionStatement_1.transformExpressionStatement],
    [typescript_1.default.SyntaxKind.ForOfStatement, transformForOfStatement_1.transformForOfStatement],
    [typescript_1.default.SyntaxKind.ForStatement, transformForStatement_1.transformForStatement],
    [typescript_1.default.SyntaxKind.FunctionDeclaration, transformFunctionDeclaration_1.transformFunctionDeclaration],
    [typescript_1.default.SyntaxKind.IfStatement, transformIfStatement_1.transformIfStatement],
    [typescript_1.default.SyntaxKind.ImportDeclaration, transformImportDeclaration_1.transformImportDeclaration],
    [typescript_1.default.SyntaxKind.ImportEqualsDeclaration, transformImportEqualsDeclaration_1.transformImportEqualsDeclaration],
    [typescript_1.default.SyntaxKind.ModuleDeclaration, transformModuleDeclaration_1.transformModuleDeclaration],
    [typescript_1.default.SyntaxKind.ReturnStatement, transformReturnStatement_1.transformReturnStatement],
    [typescript_1.default.SyntaxKind.SwitchStatement, transformSwitchStatement_1.transformSwitchStatement],
    [typescript_1.default.SyntaxKind.ThrowStatement, transformThrowStatement_1.transformThrowStatement],
    [typescript_1.default.SyntaxKind.TryStatement, transformTryStatement_1.transformTryStatement],
    [typescript_1.default.SyntaxKind.VariableStatement, transformVariableStatement_1.transformVariableStatement],
    [typescript_1.default.SyntaxKind.WhileStatement, transformWhileStatement_1.transformWhileStatement],
]);
function transformStatement(state, node) {
    const modifiers = typescript_1.default.canHaveModifiers(node) ? typescript_1.default.getModifiers(node) : undefined;
    if (modifiers === null || modifiers === void 0 ? void 0 : modifiers.some(v => v.kind === typescript_1.default.SyntaxKind.DeclareKeyword))
        return NO_EMIT();
    const transformer = TRANSFORMER_BY_KIND.get(node.kind);
    if (transformer) {
        return transformer(state, node);
    }
    (0, assert_1.assert)(false, `Unknown statement: ${(0, getKindName_1.getKindName)(node.kind)}`);
}
exports.transformStatement = transformStatement;
//# sourceMappingURL=transformStatement.js.map