"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformModuleDeclaration = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const getOrSetDefault_1 = require("../../../Shared/util/getOrSetDefault");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformIdentifier_1 = require("../expressions/transformIdentifier");
const transformStatementList_1 = require("../transformStatementList");
const hasMultipleDefinitions_1 = require("../../util/hasMultipleDefinitions");
const isSymbolMutable_1 = require("../../util/isSymbolMutable");
const isSymbolOfValue_1 = require("../../util/isSymbolOfValue");
const traversal_1 = require("../../util/traversal");
const validateIdentifier_1 = require("../../util/validateIdentifier");
const typescript_1 = __importDefault(require("typescript"));
function isDeclarationOfNamespace(declaration) {
    const modifiers = typescript_1.default.canHaveModifiers(declaration) ? typescript_1.default.getModifiers(declaration) : undefined;
    if (modifiers === null || modifiers === void 0 ? void 0 : modifiers.some(v => v.kind === typescript_1.default.SyntaxKind.DeclareKeyword)) {
        return false;
    }
    if (typescript_1.default.isModuleDeclaration(declaration) && typescript_1.default.isInstantiatedModule(declaration, false)) {
        return true;
    }
    else if (typescript_1.default.isFunctionDeclaration(declaration) && declaration.body) {
        return true;
    }
    else if (typescript_1.default.isClassDeclaration(declaration)) {
        return true;
    }
    return false;
}
function getValueDeclarationStatement(symbol) {
    var _a;
    for (const declaration of (_a = symbol.getDeclarations()) !== null && _a !== void 0 ? _a : []) {
        const statement = (0, traversal_1.getAncestor)(declaration, typescript_1.default.isStatement);
        if (statement) {
            const modifiers = typescript_1.default.canHaveModifiers(statement) ? typescript_1.default.getModifiers(statement) : undefined;
            if (typescript_1.default.isFunctionDeclaration(statement) && !statement.body)
                continue;
            if (typescript_1.default.isTypeAliasDeclaration(statement))
                continue;
            if (typescript_1.default.isInterfaceDeclaration(statement))
                continue;
            if (modifiers === null || modifiers === void 0 ? void 0 : modifiers.some(v => v.kind === typescript_1.default.SyntaxKind.DeclareKeyword))
                continue;
            return statement;
        }
    }
}
function transformNamespace(state, name, body) {
    const symbol = state.typeChecker.getSymbolAtLocation(name);
    (0, assert_1.assert)(symbol);
    (0, validateIdentifier_1.validateIdentifier)(state, name);
    const nameExp = (0, transformIdentifier_1.transformIdentifierDefined)(state, name);
    const statements = luau_ast_1.default.list.make();
    const doStatements = luau_ast_1.default.list.make();
    const containerId = luau_ast_1.default.tempId("container");
    state.setModuleIdBySymbol(symbol, containerId);
    if (state.isHoisted.get(symbol)) {
        luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: nameExp,
            operator: "=",
            right: luau_ast_1.default.map(),
        }));
    }
    else {
        luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: nameExp,
            right: luau_ast_1.default.map(),
        }));
    }
    const moduleExports = state.getModuleExports(symbol);
    if (moduleExports.length > 0) {
        luau_ast_1.default.list.push(doStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, { left: containerId, right: nameExp }));
    }
    if (typescript_1.default.isModuleBlock(body)) {
        const exportsMap = new Map();
        if (moduleExports.length > 0) {
            for (const exportSymbol of moduleExports) {
                const originalSymbol = typescript_1.default.skipAlias(exportSymbol, state.typeChecker);
                if ((0, isSymbolOfValue_1.isSymbolOfValue)(originalSymbol) && !(0, isSymbolMutable_1.isSymbolMutable)(state, originalSymbol)) {
                    const valueDeclarationStatement = getValueDeclarationStatement(exportSymbol);
                    if (valueDeclarationStatement) {
                        (0, getOrSetDefault_1.getOrSetDefault)(exportsMap, valueDeclarationStatement, () => []).push(exportSymbol.name);
                    }
                }
            }
        }
        luau_ast_1.default.list.pushList(doStatements, (0, transformStatementList_1.transformStatementList)(state, body, body.statements, {
            id: containerId,
            mapping: exportsMap,
        }));
    }
    else {
        luau_ast_1.default.list.pushList(doStatements, transformNamespace(state, body.name, body.body));
        luau_ast_1.default.list.push(doStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: luau_ast_1.default.property(containerId, body.name.text),
            operator: "=",
            right: (0, transformIdentifier_1.transformIdentifierDefined)(state, body.name),
        }));
    }
    luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.DoStatement, { statements: doStatements }));
    return statements;
}
function transformModuleDeclaration(state, node) {
    if (!typescript_1.default.isInstantiatedModule(node, false)) {
        return luau_ast_1.default.list.make();
    }
    const symbol = state.typeChecker.getSymbolAtLocation(node.name);
    if (symbol && (0, hasMultipleDefinitions_1.hasMultipleDefinitions)(symbol, declaration => isDeclarationOfNamespace(declaration))) {
        DiagnosticService_1.DiagnosticService.addDiagnosticWithCache(symbol, diagnostics_1.errors.noNamespaceMerging(node), state.multiTransformState.isReportedByMultipleDefinitionsCache);
        return luau_ast_1.default.list.make();
    }
    (0, assert_1.assert)(!typescript_1.default.isStringLiteral(node.name));
    (0, assert_1.assert)(node.body && !typescript_1.default.isIdentifier(node.body));
    return transformNamespace(state, node.name, node.body);
}
exports.transformModuleDeclaration = transformModuleDeclaration;
//# sourceMappingURL=transformModuleDeclaration.js.map