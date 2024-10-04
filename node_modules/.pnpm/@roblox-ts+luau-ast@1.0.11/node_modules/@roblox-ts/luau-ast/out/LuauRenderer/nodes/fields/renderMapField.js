"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderMapField = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
function renderMapField(state, node) {
    const { index, value } = node;
    const valueStr = (0, LuauRenderer_1.render)(state, value);
    if (LuauAST_1.default.isStringLiteral(index) && LuauAST_1.default.isValidIdentifier(index.value)) {
        return `${index.value} = ${valueStr}`;
    }
    else {
        const indexStr = (0, LuauRenderer_1.render)(state, index);
        return `[${indexStr}] = ${valueStr}`;
    }
}
exports.renderMapField = renderMapField;
//# sourceMappingURL=renderMapField.js.map