"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformVariableStatement = exports.transformVariableDeclarationList = exports.isVarDeclaration = exports.transformVariableDeclaration = exports.transformVariable = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformArrayBindingPattern_1 = require("../binding/transformArrayBindingPattern");
const transformObjectBindingPattern_1 = require("../binding/transformObjectBindingPattern");
const transformExpression_1 = require("../expressions/transformExpression");
const transformIdentifier_1 = require("../expressions/transformIdentifier");
const transformInitializer_1 = require("../transformInitializer");
const arrayBindingPatternContainsHoists_1 = require("../../util/arrayBindingPatternContainsHoists");
const checkVariableHoist_1 = require("../../util/checkVariableHoist");
const isSymbolMutable_1 = require("../../util/isSymbolMutable");
const types_1 = require("../../util/types");
const validateIdentifier_1 = require("../../util/validateIdentifier");
const wrapExpressionStatement_1 = require("../../util/wrapExpressionStatement");
const typescript_1 = __importDefault(require("typescript"));
function transformVariable(state, identifier, right) {
    (0, validateIdentifier_1.validateIdentifier)(state, identifier);
    const symbol = state.typeChecker.getSymbolAtLocation(identifier);
    (0, assert_1.assert)(symbol);
    if ((0, isSymbolMutable_1.isSymbolMutable)(state, symbol)) {
        const exportAccess = state.getModuleIdPropertyAccess(symbol);
        if (exportAccess) {
            if (right) {
                state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                    left: exportAccess,
                    operator: "=",
                    right,
                }));
            }
            return exportAccess;
        }
    }
    const left = (0, transformIdentifier_1.transformIdentifierDefined)(state, identifier);
    (0, checkVariableHoist_1.checkVariableHoist)(state, identifier, symbol);
    if (state.isHoisted.get(symbol) === true) {
        if (right) {
            state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, { left, operator: "=", right }));
        }
    }
    else {
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, { left, right }));
    }
    return left;
}
exports.transformVariable = transformVariable;
function transformOptimizedArrayBindingPattern(state, bindingPattern, rhs) {
    return state.capturePrereqs(() => {
        const ids = luau_ast_1.default.list.make();
        const statements = state.capturePrereqs(() => {
            for (const element of bindingPattern.elements) {
                if (typescript_1.default.isOmittedExpression(element)) {
                    luau_ast_1.default.list.push(ids, luau_ast_1.default.tempId());
                }
                else {
                    if (element.dotDotDotToken) {
                        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noSpreadDestructuring(element));
                        return;
                    }
                    if (typescript_1.default.isIdentifier(element.name)) {
                        (0, validateIdentifier_1.validateIdentifier)(state, element.name);
                        const id = (0, transformIdentifier_1.transformIdentifierDefined)(state, element.name);
                        luau_ast_1.default.list.push(ids, id);
                        if (element.initializer) {
                            state.prereq((0, transformInitializer_1.transformInitializer)(state, id, element.initializer));
                        }
                    }
                    else {
                        const id = luau_ast_1.default.tempId("binding");
                        luau_ast_1.default.list.push(ids, id);
                        if (element.initializer) {
                            state.prereq((0, transformInitializer_1.transformInitializer)(state, id, element.initializer));
                        }
                        if (typescript_1.default.isArrayBindingPattern(element.name)) {
                            (0, transformArrayBindingPattern_1.transformArrayBindingPattern)(state, element.name, id);
                        }
                        else {
                            (0, transformObjectBindingPattern_1.transformObjectBindingPattern)(state, element.name, id);
                        }
                    }
                }
            }
        });
        (0, assert_1.assert)(!luau_ast_1.default.list.isEmpty(ids));
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, { left: ids, right: rhs }));
        state.prereqList(statements);
    });
}
function transformVariableDeclaration(state, node) {
    const statements = luau_ast_1.default.list.make();
    let value;
    if (node.initializer) {
        luau_ast_1.default.list.pushList(statements, state.capturePrereqs(() => (value = (0, transformExpression_1.transformExpression)(state, node.initializer))));
    }
    const name = node.name;
    if (typescript_1.default.isIdentifier(name)) {
        luau_ast_1.default.list.pushList(statements, state.capturePrereqs(() => transformVariable(state, name, value)));
    }
    else {
        (0, assert_1.assert)(node.initializer && value);
        if (name.elements.length === 0) {
            if (!luau_ast_1.default.isArray(value) || !luau_ast_1.default.list.isEmpty(value.members)) {
                luau_ast_1.default.list.pushList(statements, (0, wrapExpressionStatement_1.wrapExpressionStatement)(value));
            }
            return statements;
        }
        if (typescript_1.default.isArrayBindingPattern(name)) {
            if (luau_ast_1.default.isCall(value) &&
                (0, types_1.isLuaTupleType)(state)(state.getType(node.initializer)) &&
                !(0, arrayBindingPatternContainsHoists_1.arrayBindingPatternContainsHoists)(state, name)) {
                luau_ast_1.default.list.pushList(statements, transformOptimizedArrayBindingPattern(state, name, value));
            }
            else if (luau_ast_1.default.isArray(value) &&
                !luau_ast_1.default.list.isEmpty(value.members) &&
                !(0, arrayBindingPatternContainsHoists_1.arrayBindingPatternContainsHoists)(state, name)) {
                luau_ast_1.default.list.pushList(statements, transformOptimizedArrayBindingPattern(state, name, value.members));
            }
            else {
                luau_ast_1.default.list.pushList(statements, state.capturePrereqs(() => (0, transformArrayBindingPattern_1.transformArrayBindingPattern)(state, name, state.pushToVar(value, "binding"))));
            }
        }
        else {
            luau_ast_1.default.list.pushList(statements, state.capturePrereqs(() => (0, transformObjectBindingPattern_1.transformObjectBindingPattern)(state, name, state.pushToVar(value, "binding"))));
        }
    }
    return statements;
}
exports.transformVariableDeclaration = transformVariableDeclaration;
function isVarDeclaration(node) {
    return !(node.flags & typescript_1.default.NodeFlags.Const) && !(node.flags & typescript_1.default.NodeFlags.Let);
}
exports.isVarDeclaration = isVarDeclaration;
function transformVariableDeclarationList(state, node) {
    if (isVarDeclaration(node)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noVar(node));
    }
    const statements = luau_ast_1.default.list.make();
    for (const declaration of node.declarations) {
        const [variableStatements, prereqs] = state.capture(() => transformVariableDeclaration(state, declaration));
        luau_ast_1.default.list.pushList(statements, prereqs);
        luau_ast_1.default.list.pushList(statements, variableStatements);
    }
    return statements;
}
exports.transformVariableDeclarationList = transformVariableDeclarationList;
function transformVariableStatement(state, node) {
    return transformVariableDeclarationList(state, node.declarationList);
}
exports.transformVariableStatement = transformVariableStatement;
//# sourceMappingURL=transformVariableStatement.js.map