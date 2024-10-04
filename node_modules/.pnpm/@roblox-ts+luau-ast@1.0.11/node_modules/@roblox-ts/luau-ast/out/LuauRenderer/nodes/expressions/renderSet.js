"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderSet = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
function renderSet(state, node) {
    if (LuauAST_1.default.list.isEmpty(node.members)) {
        return "{}";
    }
    let result = "{\n";
    state.block(() => {
        LuauAST_1.default.list.forEach(node.members, member => (result += state.line(`[${(0, LuauRenderer_1.render)(state, member)}] = true,`)));
    });
    result += state.indented("}");
    return result;
}
exports.renderSet = renderSet;
//# sourceMappingURL=renderSet.js.map