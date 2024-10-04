"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformPropertyDeclaration = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformExpression_1 = require("../expressions/transformExpression");
const transformPropertyName_1 = require("../transformPropertyName");
const typescript_1 = __importDefault(require("typescript"));
function transformPropertyDeclaration(state, node, name) {
    if (!typescript_1.default.hasStaticModifier(node)) {
        return luau_ast_1.default.list.make();
    }
    if (typescript_1.default.isPrivateIdentifier(node.name)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noPrivateIdentifier(node));
        return luau_ast_1.default.list.make();
    }
    if (!node.initializer) {
        return luau_ast_1.default.list.make();
    }
    return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
            expression: name,
            index: (0, transformPropertyName_1.transformPropertyName)(state, node.name),
        }),
        operator: "=",
        right: (0, transformExpression_1.transformExpression)(state, node.initializer),
    }));
}
exports.transformPropertyDeclaration = transformPropertyDeclaration;
//# sourceMappingURL=transformPropertyDeclaration.js.map