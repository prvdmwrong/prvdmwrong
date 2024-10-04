"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderMixedTable = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
function renderMixedTable(state, node) {
    if (LuauAST_1.default.list.isEmpty(node.fields)) {
        return "{}";
    }
    let result = "{\n";
    state.block(() => {
        LuauAST_1.default.list.forEach(node.fields, field => (result += state.line(`${(0, LuauRenderer_1.render)(state, field)},`)));
    });
    result += state.indented("}");
    return result;
}
exports.renderMixedTable = renderMixedTable;
//# sourceMappingURL=renderMixedTable.js.map