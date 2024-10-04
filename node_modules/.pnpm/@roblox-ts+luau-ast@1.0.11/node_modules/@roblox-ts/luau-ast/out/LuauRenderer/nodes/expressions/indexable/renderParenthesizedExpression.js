"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderParenthesizedExpression = void 0;
const LuauAST_1 = __importDefault(require("../../../../LuauAST"));
const LuauRenderer_1 = require("../../..");
function renderParenthesizedExpression(state, node) {
    let expression = node.expression;
    while (LuauAST_1.default.isParenthesizedExpression(expression)) {
        expression = expression.expression;
    }
    if (LuauAST_1.default.isSimple(expression)) {
        return (0, LuauRenderer_1.render)(state, node.expression);
    }
    else {
        return `(${(0, LuauRenderer_1.render)(state, node.expression)})`;
    }
}
exports.renderParenthesizedExpression = renderParenthesizedExpression;
//# sourceMappingURL=renderParenthesizedExpression.js.map