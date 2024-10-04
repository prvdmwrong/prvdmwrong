"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformEnumDeclaration = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformExpression_1 = require("../expressions/transformExpression");
const transformIdentifier_1 = require("../expressions/transformIdentifier");
const transformPropertyName_1 = require("../transformPropertyName");
const expressionMightMutate_1 = require("../../util/expressionMightMutate");
const hasMultipleDefinitions_1 = require("../../util/hasMultipleDefinitions");
const validateIdentifier_1 = require("../../util/validateIdentifier");
const typescript_1 = __importDefault(require("typescript"));
function needsInverseEntry(state, member) {
    return typeof state.typeChecker.getConstantValue(member) !== "string";
}
function transformEnumDeclaration(state, node) {
    if (!!typescript_1.default.getSelectedSyntacticModifierFlags(node, typescript_1.default.ModifierFlags.Const) &&
        state.compilerOptions.preserveConstEnums !== true) {
        return luau_ast_1.default.list.make();
    }
    const symbol = state.typeChecker.getSymbolAtLocation(node.name);
    if (symbol &&
        (0, hasMultipleDefinitions_1.hasMultipleDefinitions)(symbol, declaration => typescript_1.default.isEnumDeclaration(declaration) &&
            !typescript_1.default.getSelectedSyntacticModifierFlags(declaration, typescript_1.default.ModifierFlags.Const))) {
        DiagnosticService_1.DiagnosticService.addDiagnosticWithCache(symbol, diagnostics_1.errors.noEnumMerging(node), state.multiTransformState.isReportedByMultipleDefinitionsCache);
        return luau_ast_1.default.list.make();
    }
    (0, validateIdentifier_1.validateIdentifier)(state, node.name);
    const left = (0, transformIdentifier_1.transformIdentifierDefined)(state, node.name);
    const isHoisted = symbol !== undefined && state.isHoisted.get(symbol) === true;
    if (node.members.every(member => !needsInverseEntry(state, member))) {
        const right = luau_ast_1.default.map(node.members.map(member => [
            state.pushToVarIfComplex((0, transformPropertyName_1.transformPropertyName)(state, member.name)),
            luau_ast_1.default.string(state.typeChecker.getConstantValue(member)),
        ]));
        return luau_ast_1.default.list.make(isHoisted
            ? luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, { left, operator: "=", right })
            : luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, { left, right }));
    }
    const statements = state.capturePrereqs(() => {
        const inverseId = state.pushToVar(luau_ast_1.default.map(), "inverse");
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left,
            operator: "=",
            right: luau_ast_1.default.call(luau_ast_1.default.globals.setmetatable, [
                luau_ast_1.default.map(),
                luau_ast_1.default.map([[luau_ast_1.default.strings.__index, inverseId]]),
            ]),
        }));
        for (const member of node.members) {
            const name = (0, transformPropertyName_1.transformPropertyName)(state, member.name);
            const index = (0, expressionMightMutate_1.expressionMightMutate)(state, name, typescript_1.default.isComputedPropertyName(member.name) ? member.name.expression : member.name)
                ?
                    state.pushToVar(name)
                : name;
            const value = state.typeChecker.getConstantValue(member);
            let valueExp;
            if (typeof value === "string") {
                valueExp = luau_ast_1.default.string(value);
            }
            else if (typeof value === "number") {
                valueExp = luau_ast_1.default.number(value);
            }
            else {
                (0, assert_1.assert)(member.initializer);
                valueExp = state.pushToVarIfComplex((0, transformExpression_1.transformExpression)(state, member.initializer), "value");
            }
            state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                    expression: left,
                    index,
                }),
                operator: "=",
                right: valueExp,
            }));
            if (needsInverseEntry(state, member)) {
                state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                    left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                        expression: inverseId,
                        index: valueExp,
                    }),
                    operator: "=",
                    right: index,
                }));
            }
        }
    });
    const list = luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.DoStatement, { statements }));
    if (!isHoisted) {
        luau_ast_1.default.list.unshift(list, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, { left, right: undefined }));
    }
    return list;
}
exports.transformEnumDeclaration = transformEnumDeclaration;
//# sourceMappingURL=transformEnumDeclaration.js.map