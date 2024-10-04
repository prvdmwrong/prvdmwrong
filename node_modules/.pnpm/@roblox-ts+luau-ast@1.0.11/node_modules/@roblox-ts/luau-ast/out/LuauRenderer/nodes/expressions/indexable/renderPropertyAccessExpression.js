"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderPropertyAccessExpression = void 0;
const LuauAST_1 = __importDefault(require("../../../../LuauAST"));
const LuauRenderer_1 = require("../../..");
function renderPropertyAccessExpression(state, node) {
    const expStr = (0, LuauRenderer_1.render)(state, node.expression);
    const nameStr = node.name;
    if (LuauAST_1.default.isValidIdentifier(nameStr)) {
        return `${expStr}.${nameStr}`;
    }
    else {
        return `${expStr}["${nameStr}"]`;
    }
}
exports.renderPropertyAccessExpression = renderPropertyAccessExpression;
//# sourceMappingURL=renderPropertyAccessExpression.js.map