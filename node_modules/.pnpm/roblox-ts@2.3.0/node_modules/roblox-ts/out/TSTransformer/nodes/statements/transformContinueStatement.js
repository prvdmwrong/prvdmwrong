"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformContinueStatement = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const isBlockedByTryStatement_1 = require("../../util/isBlockedByTryStatement");
function transformContinueStatement(state, node) {
    if (node.label) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noLabeledStatement(node.label));
        return luau_ast_1.default.list.make();
    }
    if ((0, isBlockedByTryStatement_1.isBreakBlockedByTryStatement)(node)) {
        state.markTryUses("usesContinue");
        return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ReturnStatement, {
            expression: state.TS(node, "TRY_CONTINUE"),
        }));
    }
    return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ContinueStatement, {}));
}
exports.transformContinueStatement = transformContinueStatement;
//# sourceMappingURL=transformContinueStatement.js.map