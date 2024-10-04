"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderCallStatement = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
function renderCallStatement(state, node) {
    return state.line(`${(0, LuauRenderer_1.render)(state, node.expression)}`, node);
}
exports.renderCallStatement = renderCallStatement;
//# sourceMappingURL=renderCallStatement.js.map