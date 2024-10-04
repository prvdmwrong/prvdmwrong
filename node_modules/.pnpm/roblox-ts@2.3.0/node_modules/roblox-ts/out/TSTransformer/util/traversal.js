"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getModuleAncestor = exports.getAncestor = exports.skipUpwards = exports.skipDownwards = exports.isAncestorOf = void 0;
const typescript_1 = __importDefault(require("typescript"));
function isAncestorOf(ancestor, node) {
    do {
        if (ancestor === node) {
            return true;
        }
        node = node.parent;
    } while (node);
    return false;
}
exports.isAncestorOf = isAncestorOf;
function skipDownwards(node) {
    while (typescript_1.default.isNonNullExpression(node) ||
        typescript_1.default.isParenthesizedExpression(node) ||
        typescript_1.default.isAsExpression(node) ||
        typescript_1.default.isTypeAssertionExpression(node) ||
        typescript_1.default.isSatisfiesExpression(node)) {
        node = node.expression;
    }
    return node;
}
exports.skipDownwards = skipDownwards;
function skipUpwards(node) {
    let parent = node.parent;
    while (parent &&
        (typescript_1.default.isNonNullExpression(parent) ||
            typescript_1.default.isParenthesizedExpression(parent) ||
            typescript_1.default.isAsExpression(parent) ||
            typescript_1.default.isTypeAssertionExpression(parent) ||
            typescript_1.default.isSatisfiesExpression(parent))) {
        node = parent;
        parent = node.parent;
    }
    return node;
}
exports.skipUpwards = skipUpwards;
function getAncestor(node, check) {
    let current = node;
    while (current && !check(current)) {
        current = current.parent;
    }
    return current;
}
exports.getAncestor = getAncestor;
function isSourceFileOrModuleDeclaration(node) {
    return typescript_1.default.isSourceFile(node) || typescript_1.default.isModuleDeclaration(node);
}
function getModuleAncestor(node) {
    return getAncestor(node, isSourceFileOrModuleDeclaration);
}
exports.getModuleAncestor = getModuleAncestor;
//# sourceMappingURL=traversal.js.map