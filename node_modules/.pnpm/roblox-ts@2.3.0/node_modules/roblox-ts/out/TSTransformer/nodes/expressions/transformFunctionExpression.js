"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformFunctionExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformReturnStatement_1 = require("../statements/transformReturnStatement");
const transformParameters_1 = require("../transformParameters");
const transformStatementList_1 = require("../transformStatementList");
const wrapStatementsAsGenerator_1 = require("../../util/wrapStatementsAsGenerator");
const typescript_1 = __importDefault(require("typescript"));
function transformFunctionExpression(state, node) {
    if (node.name) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noFunctionExpressionName(node.name));
    }
    let { statements, parameters, hasDotDotDot } = (0, transformParameters_1.transformParameters)(state, node);
    const body = node.body;
    if (typescript_1.default.isFunctionBody(body)) {
        luau_ast_1.default.list.pushList(statements, (0, transformStatementList_1.transformStatementList)(state, body, body.statements));
    }
    else {
        const [returnStatements, prereqs] = state.capture(() => (0, transformReturnStatement_1.transformReturnStatementInner)(state, body));
        luau_ast_1.default.list.pushList(statements, prereqs);
        luau_ast_1.default.list.pushList(statements, returnStatements);
    }
    const isAsync = !!typescript_1.default.getSelectedSyntacticModifierFlags(node, typescript_1.default.ModifierFlags.Async);
    if (node.asteriskToken) {
        if (isAsync) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noAsyncGeneratorFunctions(node));
        }
        statements = (0, wrapStatementsAsGenerator_1.wrapStatementsAsGenerator)(state, node, statements);
    }
    let expression = luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.FunctionExpression, {
        hasDotDotDot,
        parameters,
        statements,
    });
    if (isAsync) {
        expression = luau_ast_1.default.call(state.TS(node, "async"), [expression]);
    }
    return expression;
}
exports.transformFunctionExpression = transformFunctionExpression;
//# sourceMappingURL=transformFunctionExpression.js.map