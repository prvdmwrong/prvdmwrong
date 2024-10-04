"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderIfExpression = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
const needsParentheses_1 = require("../../util/needsParentheses");
function renderIfExpression(state, node) {
    let result = `if ${(0, LuauRenderer_1.render)(state, node.condition)} then ${(0, LuauRenderer_1.render)(state, node.expression)} `;
    let currentAlternative = node.alternative;
    while (LuauAST_1.default.isIfExpression(currentAlternative)) {
        const condition = (0, LuauRenderer_1.render)(state, currentAlternative.condition);
        const expression = (0, LuauRenderer_1.render)(state, currentAlternative.expression);
        result += `elseif ${condition} then ${expression} `;
        currentAlternative = currentAlternative.alternative;
    }
    result += `else ${(0, LuauRenderer_1.render)(state, currentAlternative)}`;
    if ((0, needsParentheses_1.needsParentheses)(node)) {
        result = `(${result})`;
    }
    return result;
}
exports.renderIfExpression = renderIfExpression;
//# sourceMappingURL=renderIfExpression.js.map