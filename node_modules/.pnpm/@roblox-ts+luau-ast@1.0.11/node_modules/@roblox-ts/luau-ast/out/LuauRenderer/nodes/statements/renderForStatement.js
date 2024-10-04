"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderForStatement = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
const renderStatements_1 = require("../../util/renderStatements");
function renderForStatement(state, node) {
    const idsStr = LuauAST_1.default.list.mapToArray(node.ids, id => (0, LuauRenderer_1.render)(state, id)).join(", ") || "_";
    const expStr = (0, LuauRenderer_1.render)(state, node.expression);
    let result = "";
    result += state.line(`for ${idsStr} in ${expStr} do`);
    result += state.block(() => (0, renderStatements_1.renderStatements)(state, node.statements));
    result += state.line(`end`);
    return result;
}
exports.renderForStatement = renderForStatement;
//# sourceMappingURL=renderForStatement.js.map