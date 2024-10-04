"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isUsedAsStatement = void 0;
const traversal_1 = require("./traversal");
const typescript_1 = __importDefault(require("typescript"));
function isUsedAsStatement(expression) {
    const child = (0, traversal_1.skipUpwards)(expression);
    const parent = child.parent;
    if (typescript_1.default.isExpressionStatement(parent)) {
        return true;
    }
    if (typescript_1.default.isForStatement(parent) && parent.condition !== child) {
        return true;
    }
    if (typescript_1.default.isDeleteExpression(parent) && isUsedAsStatement(parent)) {
        return true;
    }
    return false;
}
exports.isUsedAsStatement = isUsedAsStatement;
//# sourceMappingURL=isUsedAsStatement.js.map