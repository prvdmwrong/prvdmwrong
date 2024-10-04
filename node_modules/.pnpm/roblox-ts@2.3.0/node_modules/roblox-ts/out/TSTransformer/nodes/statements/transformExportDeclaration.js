"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformExportDeclaration = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const assert_1 = require("../../../Shared/util/assert");
const cleanModuleName_1 = require("../../util/cleanModuleName");
const createImportExpression_1 = require("../../util/createImportExpression");
const isSymbolOfValue_1 = require("../../util/isSymbolOfValue");
const typescript_1 = __importDefault(require("typescript"));
function isExportSpecifierValue(state, element) {
    if (element.isTypeOnly) {
        return false;
    }
    if (state.resolver.isReferencedAliasDeclaration(element)) {
        return true;
    }
    const aliasSymbol = state.typeChecker.getSymbolAtLocation(element.name);
    if (aliasSymbol && (0, isSymbolOfValue_1.isSymbolOfValue)(typescript_1.default.skipAlias(aliasSymbol, state.typeChecker))) {
        return true;
    }
    return false;
}
function countImportExpUses(state, exportClause) {
    let uses = 0;
    if (exportClause && typescript_1.default.isNamedExports(exportClause)) {
        for (const element of exportClause.elements) {
            if (isExportSpecifierValue(state, element)) {
                uses++;
            }
        }
    }
    else {
        uses++;
    }
    return uses;
}
function transformExportFrom(state, node) {
    var _a;
    (0, assert_1.assert)(node.moduleSpecifier && typescript_1.default.isStringLiteral(node.moduleSpecifier));
    const statements = luau_ast_1.default.list.make();
    let importExp;
    const exportClause = node.exportClause;
    const uses = countImportExpUses(state, exportClause);
    if (uses === 1) {
        importExp = (0, createImportExpression_1.createImportExpression)(state, node.getSourceFile(), node.moduleSpecifier);
    }
    else if (uses > 1) {
        const moduleName = node.moduleSpecifier.text.split("/");
        importExp = luau_ast_1.default.tempId((0, cleanModuleName_1.cleanModuleName)(moduleName[moduleName.length - 1]));
        luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: importExp,
            right: (0, createImportExpression_1.createImportExpression)(state, node.getSourceFile(), node.moduleSpecifier),
        }));
    }
    if (!importExp) {
        return statements;
    }
    const moduleId = state.getModuleIdFromNode(node);
    if (exportClause) {
        if (typescript_1.default.isNamedExports(exportClause)) {
            for (const element of exportClause.elements) {
                if (isExportSpecifierValue(state, element)) {
                    luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                        left: luau_ast_1.default.property(moduleId, element.name.text),
                        operator: "=",
                        right: luau_ast_1.default.property(importExp, ((_a = element.propertyName) !== null && _a !== void 0 ? _a : element.name).text),
                    }));
                }
            }
        }
        else {
            luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: luau_ast_1.default.property(moduleId, exportClause.name.text),
                operator: "=",
                right: importExp,
            }));
        }
    }
    else {
        const keyId = luau_ast_1.default.tempId("k");
        const valueId = luau_ast_1.default.tempId("v");
        luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ForStatement, {
            ids: luau_ast_1.default.list.make(keyId, valueId),
            expression: luau_ast_1.default.binary(importExp, "or", luau_ast_1.default.map()),
            statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                    expression: moduleId,
                    index: keyId,
                }),
                operator: "=",
                right: valueId,
            })),
        }));
    }
    state.hasExportFrom = true;
    return statements;
}
function transformExportDeclaration(state, node) {
    if (node.isTypeOnly)
        return luau_ast_1.default.list.make();
    if (node.moduleSpecifier) {
        return transformExportFrom(state, node);
    }
    return luau_ast_1.default.list.make();
}
exports.transformExportDeclaration = transformExportDeclaration;
//# sourceMappingURL=transformExportDeclaration.js.map