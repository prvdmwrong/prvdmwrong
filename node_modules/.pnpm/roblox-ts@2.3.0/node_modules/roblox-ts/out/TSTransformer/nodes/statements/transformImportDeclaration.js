"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformImportDeclaration = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const Lazy_1 = require("../../../Shared/classes/Lazy");
const assert_1 = require("../../../Shared/util/assert");
const transformVariableStatement_1 = require("./transformVariableStatement");
const cleanModuleName_1 = require("../../util/cleanModuleName");
const createImportExpression_1 = require("../../util/createImportExpression");
const getOriginalSymbolOfNode_1 = require("../../util/getOriginalSymbolOfNode");
const getSourceFileFromModuleSpecifier_1 = require("../../util/getSourceFileFromModuleSpecifier");
const isSymbolOfValue_1 = require("../../util/isSymbolOfValue");
const typescript_1 = __importDefault(require("typescript"));
function countImportExpUses(state, importClause) {
    let uses = 0;
    if (importClause.name) {
        const symbol = (0, getOriginalSymbolOfNode_1.getOriginalSymbolOfNode)(state.typeChecker, importClause.name);
        if (state.resolver.isReferencedAliasDeclaration(importClause) && (!symbol || (0, isSymbolOfValue_1.isSymbolOfValue)(symbol))) {
            uses++;
        }
    }
    if (importClause.namedBindings) {
        if (typescript_1.default.isNamespaceImport(importClause.namedBindings)) {
            uses++;
        }
        else {
            for (const element of importClause.namedBindings.elements) {
                const symbol = (0, getOriginalSymbolOfNode_1.getOriginalSymbolOfNode)(state.typeChecker, element.name);
                if (state.resolver.isReferencedAliasDeclaration(element) && (!symbol || (0, isSymbolOfValue_1.isSymbolOfValue)(symbol))) {
                    uses++;
                }
            }
        }
    }
    return uses;
}
function transformImportDeclaration(state, node) {
    const importClause = node.importClause;
    if (importClause && importClause.isTypeOnly)
        return luau_ast_1.default.list.make();
    const statements = luau_ast_1.default.list.make();
    (0, assert_1.assert)(typescript_1.default.isStringLiteral(node.moduleSpecifier));
    const importExp = new Lazy_1.Lazy(() => (0, createImportExpression_1.createImportExpression)(state, node.getSourceFile(), node.moduleSpecifier));
    if (importClause) {
        const uses = countImportExpUses(state, importClause);
        if (uses > 1) {
            const moduleName = node.moduleSpecifier.text.split("/");
            const id = luau_ast_1.default.tempId((0, cleanModuleName_1.cleanModuleName)(moduleName[moduleName.length - 1]));
            luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
                left: id,
                right: importExp.get(),
            }));
            importExp.set(id);
        }
        const importClauseName = importClause.name;
        if (importClauseName) {
            const symbol = (0, getOriginalSymbolOfNode_1.getOriginalSymbolOfNode)(state.typeChecker, importClauseName);
            if (state.resolver.isReferencedAliasDeclaration(importClause) && (!symbol || (0, isSymbolOfValue_1.isSymbolOfValue)(symbol))) {
                const moduleFile = (0, getSourceFileFromModuleSpecifier_1.getSourceFileFromModuleSpecifier)(state, node.moduleSpecifier);
                const moduleSymbol = moduleFile && state.typeChecker.getSymbolAtLocation(moduleFile);
                if (moduleSymbol && state.getModuleExports(moduleSymbol).some(v => v.name === "default")) {
                    luau_ast_1.default.list.pushList(statements, state.capturePrereqs(() => (0, transformVariableStatement_1.transformVariable)(state, importClauseName, luau_ast_1.default.property(importExp.get(), "default"))));
                }
                else {
                    luau_ast_1.default.list.pushList(statements, state.capturePrereqs(() => (0, transformVariableStatement_1.transformVariable)(state, importClauseName, importExp.get())));
                }
            }
        }
        const importClauseNamedBindings = importClause.namedBindings;
        if (importClauseNamedBindings) {
            if (typescript_1.default.isNamespaceImport(importClauseNamedBindings)) {
                luau_ast_1.default.list.pushList(statements, state.capturePrereqs(() => (0, transformVariableStatement_1.transformVariable)(state, importClauseNamedBindings.name, importExp.get())));
            }
            else {
                for (const element of importClauseNamedBindings.elements) {
                    const symbol = (0, getOriginalSymbolOfNode_1.getOriginalSymbolOfNode)(state.typeChecker, element.name);
                    if (state.resolver.isReferencedAliasDeclaration(element) && (!symbol || (0, isSymbolOfValue_1.isSymbolOfValue)(symbol))) {
                        luau_ast_1.default.list.pushList(statements, state.capturePrereqs(() => {
                            var _a;
                            return (0, transformVariableStatement_1.transformVariable)(state, element.name, luau_ast_1.default.property(importExp.get(), ((_a = element.propertyName) !== null && _a !== void 0 ? _a : element.name).text));
                        }));
                    }
                }
            }
        }
    }
    if (!importClause ||
        (state.compilerOptions.importsNotUsedAsValues === typescript_1.default.ImportsNotUsedAsValues.Preserve &&
            luau_ast_1.default.list.isEmpty(statements))) {
        const expression = importExp.get();
        if (luau_ast_1.default.isCallExpression(expression)) {
            luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, { expression }));
        }
    }
    return statements;
}
exports.transformImportDeclaration = transformImportDeclaration;
//# sourceMappingURL=transformImportDeclaration.js.map