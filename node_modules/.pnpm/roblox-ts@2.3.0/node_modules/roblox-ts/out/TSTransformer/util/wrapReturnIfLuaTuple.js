"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.wrapReturnIfLuaTuple = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const arrayBindingPatternContainsHoists_1 = require("./arrayBindingPatternContainsHoists");
const traversal_1 = require("./traversal");
const types_1 = require("./types");
const typescript_1 = __importDefault(require("typescript"));
function shouldWrapLuaTuple(state, node, exp) {
    if (!luau_ast_1.default.isCall(exp)) {
        return true;
    }
    const child = (0, traversal_1.skipUpwards)(node);
    const parent = child.parent;
    if (typescript_1.default.isExpressionStatement(parent)) {
        return false;
    }
    if (typescript_1.default.isForStatement(parent) && parent.condition !== child) {
        return false;
    }
    if (typescript_1.default.isVariableDeclaration(parent) &&
        typescript_1.default.isArrayBindingPattern(parent.name) &&
        !(0, arrayBindingPatternContainsHoists_1.arrayBindingPatternContainsHoists)(state, parent.name)) {
        return false;
    }
    if (typescript_1.default.isAssignmentExpression(parent) && typescript_1.default.isArrayLiteralExpression(parent.left)) {
        return false;
    }
    if (typescript_1.default.isElementAccessExpression(parent)) {
        return false;
    }
    if (typescript_1.default.isReturnStatement(parent)) {
        return false;
    }
    if (typescript_1.default.isVoidExpression(parent)) {
        return false;
    }
    return true;
}
function wrapReturnIfLuaTuple(state, node, exp) {
    if ((0, types_1.isLuaTupleType)(state)(state.getType(node)) && shouldWrapLuaTuple(state, node, exp)) {
        return luau_ast_1.default.array([exp]);
    }
    return exp;
}
exports.wrapReturnIfLuaTuple = wrapReturnIfLuaTuple;
//# sourceMappingURL=wrapReturnIfLuaTuple.js.map