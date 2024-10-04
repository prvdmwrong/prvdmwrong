"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderBinaryExpression = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
const needsParentheses_1 = require("../../util/needsParentheses");
function renderBinaryExpression(state, node) {
    let result = `${(0, LuauRenderer_1.render)(state, node.left)} ${node.operator} ${(0, LuauRenderer_1.render)(state, node.right)}`;
    if ((0, needsParentheses_1.needsParentheses)(node)) {
        result = `(${result})`;
    }
    return result;
}
exports.renderBinaryExpression = renderBinaryExpression;
//# sourceMappingURL=renderBinaryExpression.js.map