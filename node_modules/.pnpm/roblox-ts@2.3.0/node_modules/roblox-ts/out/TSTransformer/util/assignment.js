"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createCompoundAssignmentExpression = exports.createCompoundAssignmentStatement = exports.createAssignmentExpression = exports.getSimpleAssignmentOperator = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const createBinaryFromOperator_1 = require("./createBinaryFromOperator");
const types_1 = require("./types");
const typescript_1 = __importDefault(require("typescript"));
const COMPOUND_OPERATOR_MAP = new Map([
    [typescript_1.default.SyntaxKind.MinusEqualsToken, "-="],
    [typescript_1.default.SyntaxKind.AsteriskEqualsToken, "*="],
    [typescript_1.default.SyntaxKind.SlashEqualsToken, "/="],
    [typescript_1.default.SyntaxKind.AsteriskAsteriskEqualsToken, "^="],
    [typescript_1.default.SyntaxKind.PercentEqualsToken, "%="],
    [typescript_1.default.SyntaxKind.PlusPlusToken, "+="],
    [typescript_1.default.SyntaxKind.MinusMinusToken, "-="],
    [typescript_1.default.SyntaxKind.EqualsToken, "="],
]);
function getSimpleAssignmentOperator(leftType, operatorKind, rightType) {
    if (operatorKind === typescript_1.default.SyntaxKind.PlusEqualsToken) {
        return (0, types_1.isDefinitelyType)(leftType, types_1.isStringType) || (0, types_1.isDefinitelyType)(rightType, types_1.isStringType) ? "..=" : "+=";
    }
    return COMPOUND_OPERATOR_MAP.get(operatorKind);
}
exports.getSimpleAssignmentOperator = getSimpleAssignmentOperator;
function createAssignmentExpression(state, readable, operator, value) {
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: readable,
        operator,
        right: value,
    }));
    return readable;
}
exports.createAssignmentExpression = createAssignmentExpression;
function createCompoundAssignmentStatement(state, node, writable, writableType, readable, operator, value, valueType) {
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: writable,
        operator: "=",
        right: (0, createBinaryFromOperator_1.createBinaryFromOperator)(state, node, readable, writableType, operator, value, valueType),
    });
}
exports.createCompoundAssignmentStatement = createCompoundAssignmentStatement;
function createCompoundAssignmentExpression(state, node, writable, writableType, readable, operator, value, valueType) {
    return createAssignmentExpression(state, writable, "=", (0, createBinaryFromOperator_1.createBinaryFromOperator)(state, node, readable, writableType, operator, value, valueType));
}
exports.createCompoundAssignmentExpression = createCompoundAssignmentExpression;
//# sourceMappingURL=assignment.js.map