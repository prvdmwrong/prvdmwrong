"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformPrefixUnaryExpression = exports.transformPostfixUnaryExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformExpression_1 = require("./transformExpression");
const transformWritable_1 = require("../transformWritable");
const assertNever_1 = require("../../util/assertNever");
const createTruthinessChecks_1 = require("../../util/createTruthinessChecks");
const types_1 = require("../../util/types");
const validateNotAny_1 = require("../../util/validateNotAny");
const typescript_1 = __importDefault(require("typescript"));
function transformPostfixUnaryExpression(state, node) {
    (0, validateNotAny_1.validateNotAnyType)(state, node.operand);
    const writable = (0, transformWritable_1.transformWritableExpression)(state, node.operand, true);
    const origValue = luau_ast_1.default.tempId("original");
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
        left: origValue,
        right: writable,
    }));
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: writable,
        operator: node.operator === typescript_1.default.SyntaxKind.PlusPlusToken
            ? "+="
            : node.operator === typescript_1.default.SyntaxKind.MinusMinusToken
                ? "-="
                : (0, assertNever_1.assertNever)(node.operator, "transformPostfixUnaryExpression"),
        right: luau_ast_1.default.number(1),
    }));
    return origValue;
}
exports.transformPostfixUnaryExpression = transformPostfixUnaryExpression;
function transformPrefixUnaryExpression(state, node) {
    (0, validateNotAny_1.validateNotAnyType)(state, node.operand);
    if (node.operator === typescript_1.default.SyntaxKind.PlusPlusToken || node.operator === typescript_1.default.SyntaxKind.MinusMinusToken) {
        const writable = (0, transformWritable_1.transformWritableExpression)(state, node.operand, true);
        const operator = node.operator === typescript_1.default.SyntaxKind.PlusPlusToken ? "+=" : "-=";
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: writable,
            operator,
            right: luau_ast_1.default.number(1),
        }));
        return writable;
    }
    else if (node.operator === typescript_1.default.SyntaxKind.PlusToken) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noUnaryPlus(node));
        return (0, transformExpression_1.transformExpression)(state, node.operand);
    }
    else if (node.operator === typescript_1.default.SyntaxKind.MinusToken) {
        if (!(0, types_1.isDefinitelyType)(state.getType(node.operand), types_1.isNumberType)) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noNonNumberUnaryMinus(node));
        }
        return luau_ast_1.default.unary("-", (0, transformExpression_1.transformExpression)(state, node.operand));
    }
    else if (node.operator === typescript_1.default.SyntaxKind.ExclamationToken) {
        const checks = (0, createTruthinessChecks_1.createTruthinessChecks)(state, (0, transformExpression_1.transformExpression)(state, node.operand), node.operand);
        return luau_ast_1.default.unary("not", checks);
    }
    else if (node.operator === typescript_1.default.SyntaxKind.TildeToken) {
        return luau_ast_1.default.call(luau_ast_1.default.property(luau_ast_1.default.globals.bit32, "bnot"), [(0, transformExpression_1.transformExpression)(state, node.operand)]);
    }
    return (0, assertNever_1.assertNever)(node.operator, "transformPrefixUnaryExpression");
}
exports.transformPrefixUnaryExpression = transformPrefixUnaryExpression;
//# sourceMappingURL=transformUnaryExpression.js.map