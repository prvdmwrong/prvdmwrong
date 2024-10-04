"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformThisExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const TSTransformer_1 = require("../..");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const typescript_1 = __importDefault(require("typescript"));
function transformThisExpression(state, node) {
    const symbol = state.typeChecker.getSymbolAtLocation(node);
    if (symbol === state.services.macroManager.getSymbolOrThrow(TSTransformer_1.SYMBOL_NAMES.globalThis)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noGlobalThis(node));
    }
    if (symbol) {
        const container = typescript_1.default.getThisContainer(node, false, false);
        const isStatic = typescript_1.default.hasStaticModifier(container) || typescript_1.default.isClassStaticBlockDeclaration(container);
        if (isStatic && !typescript_1.default.isMethodDeclaration(container) && typescript_1.default.isClassLike(container.parent)) {
            const identifier = state.classIdentifierMap.get(container.parent);
            if (identifier) {
                return identifier;
            }
        }
    }
    return luau_ast_1.default.globals.self;
}
exports.transformThisExpression = transformThisExpression;
//# sourceMappingURL=transformThisExpression.js.map