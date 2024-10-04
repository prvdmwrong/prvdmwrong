"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformFunctionDeclaration = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformIdentifier_1 = require("../expressions/transformIdentifier");
const transformParameters_1 = require("../transformParameters");
const transformStatementList_1 = require("../transformStatementList");
const validateIdentifier_1 = require("../../util/validateIdentifier");
const wrapStatementsAsGenerator_1 = require("../../util/wrapStatementsAsGenerator");
const typescript_1 = __importDefault(require("typescript"));
function transformFunctionDeclaration(state, node) {
    if (!node.body) {
        return luau_ast_1.default.list.make();
    }
    const isExportDefault = !!typescript_1.default.getSelectedSyntacticModifierFlags(node, typescript_1.default.ModifierFlags.ExportDefault);
    (0, assert_1.assert)(node.name || isExportDefault);
    if (node.name) {
        (0, validateIdentifier_1.validateIdentifier)(state, node.name);
    }
    const name = node.name ? (0, transformIdentifier_1.transformIdentifierDefined)(state, node.name) : luau_ast_1.default.id("default");
    let { statements, parameters, hasDotDotDot } = (0, transformParameters_1.transformParameters)(state, node);
    luau_ast_1.default.list.pushList(statements, (0, transformStatementList_1.transformStatementList)(state, node.body, node.body.statements));
    let localize = isExportDefault;
    if (node.name) {
        const symbol = state.typeChecker.getSymbolAtLocation(node.name);
        (0, assert_1.assert)(symbol);
        localize = state.isHoisted.get(symbol) !== true;
    }
    const isAsync = !!typescript_1.default.getSelectedSyntacticModifierFlags(node, typescript_1.default.ModifierFlags.Async);
    if (node.asteriskToken) {
        if (isAsync) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noAsyncGeneratorFunctions(node));
        }
        statements = (0, wrapStatementsAsGenerator_1.wrapStatementsAsGenerator)(state, node, statements);
    }
    if (isAsync) {
        const right = luau_ast_1.default.call(state.TS(node, "async"), [
            luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.FunctionExpression, {
                hasDotDotDot,
                parameters,
                statements,
            }),
        ]);
        if (localize) {
            return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
                left: name,
                right,
            }));
        }
        else {
            return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: name,
                operator: "=",
                right,
            }));
        }
    }
    else {
        return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.FunctionDeclaration, { localize, name, statements, parameters, hasDotDotDot }));
    }
}
exports.transformFunctionDeclaration = transformFunctionDeclaration;
//# sourceMappingURL=transformFunctionDeclaration.js.map