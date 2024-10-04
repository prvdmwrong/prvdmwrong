"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createBinaryFromOperator = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const assert_1 = require("../../Shared/util/assert");
const getKindName_1 = require("./getKindName");
const types_1 = require("./types");
const wrapExpressionStatement_1 = require("./wrapExpressionStatement");
const typescript_1 = __importDefault(require("typescript"));
const OPERATOR_MAP = new Map([
    [typescript_1.default.SyntaxKind.LessThanToken, "<"],
    [typescript_1.default.SyntaxKind.GreaterThanToken, ">"],
    [typescript_1.default.SyntaxKind.LessThanEqualsToken, "<="],
    [typescript_1.default.SyntaxKind.GreaterThanEqualsToken, ">="],
    [typescript_1.default.SyntaxKind.EqualsEqualsEqualsToken, "=="],
    [typescript_1.default.SyntaxKind.ExclamationEqualsEqualsToken, "~="],
    [typescript_1.default.SyntaxKind.MinusToken, "-"],
    [typescript_1.default.SyntaxKind.AsteriskToken, "*"],
    [typescript_1.default.SyntaxKind.SlashToken, "/"],
    [typescript_1.default.SyntaxKind.AsteriskAsteriskToken, "^"],
    [typescript_1.default.SyntaxKind.PercentToken, "%"],
]);
const BITWISE_OPERATOR_MAP = new Map([
    [typescript_1.default.SyntaxKind.AmpersandToken, "band"],
    [typescript_1.default.SyntaxKind.BarToken, "bor"],
    [typescript_1.default.SyntaxKind.CaretToken, "bxor"],
    [typescript_1.default.SyntaxKind.LessThanLessThanToken, "lshift"],
    [typescript_1.default.SyntaxKind.GreaterThanGreaterThanGreaterThanToken, "rshift"],
    [typescript_1.default.SyntaxKind.GreaterThanGreaterThanToken, "arshift"],
    [typescript_1.default.SyntaxKind.AmpersandEqualsToken, "band"],
    [typescript_1.default.SyntaxKind.BarEqualsToken, "bor"],
    [typescript_1.default.SyntaxKind.CaretEqualsToken, "bxor"],
    [typescript_1.default.SyntaxKind.LessThanLessThanEqualsToken, "lshift"],
    [typescript_1.default.SyntaxKind.GreaterThanGreaterThanGreaterThanEqualsToken, "rshift"],
    [typescript_1.default.SyntaxKind.GreaterThanGreaterThanEqualsToken, "arshift"],
]);
function createBinaryAdd(left, leftType, right, rightType) {
    const leftIsString = (0, types_1.isDefinitelyType)(leftType, types_1.isStringType);
    const rightIsString = (0, types_1.isDefinitelyType)(rightType, types_1.isStringType);
    if (leftIsString || rightIsString) {
        return luau_ast_1.default.binary(leftIsString ? left : luau_ast_1.default.call(luau_ast_1.default.globals.tostring, [left]), "..", rightIsString ? right : luau_ast_1.default.call(luau_ast_1.default.globals.tostring, [right]));
    }
    else {
        return luau_ast_1.default.binary(left, "+", right);
    }
}
function createBinaryFromOperator(state, node, left, leftType, operatorKind, right, rightType) {
    const operator = OPERATOR_MAP.get(operatorKind);
    if (operator !== undefined) {
        return luau_ast_1.default.binary(left, operator, right);
    }
    if (operatorKind === typescript_1.default.SyntaxKind.PlusToken || operatorKind === typescript_1.default.SyntaxKind.PlusEqualsToken) {
        return createBinaryAdd(left, leftType, right, rightType);
    }
    const bit32Name = BITWISE_OPERATOR_MAP.get(operatorKind);
    if (bit32Name !== undefined) {
        return luau_ast_1.default.call(luau_ast_1.default.property(luau_ast_1.default.globals.bit32, bit32Name), [left, right]);
    }
    if (operatorKind === typescript_1.default.SyntaxKind.CommaToken) {
        state.prereqList((0, wrapExpressionStatement_1.wrapExpressionStatement)(left));
        return right;
    }
    (0, assert_1.assert)(false, `createBinaryFromOperator unknown operator: ${(0, getKindName_1.getKindName)(operatorKind)}`);
}
exports.createBinaryFromOperator = createBinaryFromOperator;
//# sourceMappingURL=createBinaryFromOperator.js.map