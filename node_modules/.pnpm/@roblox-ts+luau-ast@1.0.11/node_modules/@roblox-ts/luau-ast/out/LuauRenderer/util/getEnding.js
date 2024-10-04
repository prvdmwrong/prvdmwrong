"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getEnding = void 0;
const LuauAST_1 = __importDefault(require("../../LuauAST"));
const assert_1 = require("../../LuauAST/util/assert");
function endsWithIndexableExpressionInner(node) {
    if (LuauAST_1.default.isIndexableExpression(node)) {
        return true;
    }
    else if (LuauAST_1.default.isBinaryExpression(node)) {
        return endsWithIndexableExpressionInner(node.right);
    }
    else if (LuauAST_1.default.isUnaryExpression(node)) {
        return endsWithIndexableExpressionInner(node.expression);
    }
    else if (LuauAST_1.default.isIfExpression(node)) {
        return endsWithIndexableExpressionInner(node.alternative);
    }
    return false;
}
function endsWithIndexableExpression(node) {
    if (LuauAST_1.default.isCallStatement(node)) {
        return true;
    }
    else if (LuauAST_1.default.isVariableDeclaration(node) || LuauAST_1.default.isAssignment(node)) {
        let furthestRight;
        if (node.right) {
            if (LuauAST_1.default.list.isList(node.right)) {
                (0, assert_1.assert)(LuauAST_1.default.list.isNonEmpty(node.right));
                furthestRight = node.right.tail.value;
            }
            else {
                furthestRight = node.right;
            }
        }
        else if (LuauAST_1.default.list.isList(node.left)) {
            (0, assert_1.assert)(LuauAST_1.default.list.isNonEmpty(node.left));
            furthestRight = node.left.tail.value;
        }
        else {
            furthestRight = node.left;
        }
        return endsWithIndexableExpressionInner(furthestRight);
    }
    return false;
}
function startsWithParenthesisInner(node) {
    if (LuauAST_1.default.isParenthesizedExpression(node)) {
        return true;
    }
    else if (LuauAST_1.default.isCall(node) || LuauAST_1.default.isPropertyAccessExpression(node) || LuauAST_1.default.isComputedIndexExpression(node)) {
        return startsWithParenthesisInner(node.expression);
    }
    return false;
}
function startsWithParenthesis(node) {
    if (LuauAST_1.default.isCallStatement(node)) {
        return startsWithParenthesisInner(node.expression.expression);
    }
    else if (LuauAST_1.default.isAssignment(node)) {
        if (LuauAST_1.default.list.isList(node.left)) {
            (0, assert_1.assert)(LuauAST_1.default.list.isNonEmpty(node.left));
            return startsWithParenthesisInner(node.left.head.value);
        }
        else {
            return startsWithParenthesisInner(node.left);
        }
    }
    return false;
}
function getNextNonComment(state) {
    var _a;
    let listNode = (_a = state.peekListNode()) === null || _a === void 0 ? void 0 : _a.next;
    while (listNode && LuauAST_1.default.isComment(listNode.value)) {
        listNode = listNode.next;
    }
    return listNode === null || listNode === void 0 ? void 0 : listNode.value;
}
function getEnding(state, node) {
    const nextStatement = getNextNonComment(state);
    if (nextStatement !== undefined && endsWithIndexableExpression(node) && startsWithParenthesis(nextStatement)) {
        return ";";
    }
    else {
        return "";
    }
}
exports.getEnding = getEnding;
//# sourceMappingURL=getEnding.js.map