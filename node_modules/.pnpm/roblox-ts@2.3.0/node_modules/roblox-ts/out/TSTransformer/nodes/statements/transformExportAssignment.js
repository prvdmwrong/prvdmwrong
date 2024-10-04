"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformExportAssignment = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformExpression_1 = require("../expressions/transformExpression");
const isSymbolMutable_1 = require("../../util/isSymbolMutable");
const isSymbolOfValue_1 = require("../../util/isSymbolOfValue");
const typescript_1 = __importDefault(require("typescript"));
function transformExportEquals(state, node) {
    state.hasExportEquals = true;
    const sourceFile = node.getSourceFile();
    const finalStatement = sourceFile.statements[sourceFile.statements.length - 1];
    if (finalStatement === node) {
        return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ReturnStatement, { expression: (0, transformExpression_1.transformExpression)(state, node.expression) }));
    }
    else {
        return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: state.getModuleIdFromNode(node),
            right: (0, transformExpression_1.transformExpression)(state, node.expression),
        }));
    }
}
function transformExportDefault(state, node) {
    const statements = luau_ast_1.default.list.make();
    const [expression, prereqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, node.expression));
    luau_ast_1.default.list.pushList(statements, prereqs);
    luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
        left: luau_ast_1.default.id("default"),
        right: expression,
    }));
    return statements;
}
function transformExportAssignment(state, node) {
    const symbol = state.typeChecker.getSymbolAtLocation(node.expression);
    if (symbol && (0, isSymbolMutable_1.isSymbolMutable)(state, symbol)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noExportAssignmentLet(node));
    }
    if (symbol && !(0, isSymbolOfValue_1.isSymbolOfValue)(typescript_1.default.skipAlias(symbol, state.typeChecker))) {
        return luau_ast_1.default.list.make();
    }
    if (node.isExportEquals) {
        return transformExportEquals(state, node);
    }
    else {
        return transformExportDefault(state, node);
    }
}
exports.transformExportAssignment = transformExportAssignment;
//# sourceMappingURL=transformExportAssignment.js.map