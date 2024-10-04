"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderReturnStatement = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
function renderReturnStatement(state, node) {
    const expStr = LuauAST_1.default.list.isList(node.expression)
        ? LuauAST_1.default.list.mapToArray(node.expression, exp => (0, LuauRenderer_1.render)(state, exp)).join(", ")
        : (0, LuauRenderer_1.render)(state, node.expression);
    return state.line(`return ${expStr}`);
}
exports.renderReturnStatement = renderReturnStatement;
//# sourceMappingURL=renderReturnStatement.js.map