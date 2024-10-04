"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderComputedIndexExpression = void 0;
const LuauAST_1 = __importDefault(require("../../../../LuauAST"));
const LuauRenderer_1 = require("../../..");
function renderComputedIndexExpression(state, node) {
    const expStr = (0, LuauRenderer_1.render)(state, node.expression);
    if (LuauAST_1.default.isStringLiteral(node.index) && LuauAST_1.default.isValidIdentifier(node.index.value)) {
        return `${expStr}.${node.index.value}`;
    }
    else {
        const indexStr = (0, LuauRenderer_1.render)(state, node.index);
        return `${expStr}[${indexStr}]`;
    }
}
exports.renderComputedIndexExpression = renderComputedIndexExpression;
//# sourceMappingURL=renderComputedIndexExpression.js.map