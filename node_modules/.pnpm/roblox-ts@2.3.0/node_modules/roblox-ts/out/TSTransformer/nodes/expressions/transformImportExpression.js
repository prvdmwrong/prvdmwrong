"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformImportExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const createImportExpression_1 = require("../../util/createImportExpression");
const typescript_1 = __importDefault(require("typescript"));
function transformImportExpression(state, node) {
    const moduleSpecifier = node.arguments[0];
    if (!moduleSpecifier || !typescript_1.default.isStringLiteral(moduleSpecifier)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noNonStringModuleSpecifier(node));
        return luau_ast_1.default.none();
    }
    const importExpression = (0, createImportExpression_1.createImportExpression)(state, node.getSourceFile(), moduleSpecifier);
    const resolveId = luau_ast_1.default.id("resolve");
    return luau_ast_1.default.call(luau_ast_1.default.property(state.TS(node, "Promise"), "new"), [
        luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.FunctionExpression, {
            hasDotDotDot: false,
            parameters: luau_ast_1.default.list.make(resolveId),
            statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
                expression: luau_ast_1.default.call(resolveId, [importExpression]),
            })),
        }),
    ]);
}
exports.transformImportExpression = transformImportExpression;
//# sourceMappingURL=transformImportExpression.js.map