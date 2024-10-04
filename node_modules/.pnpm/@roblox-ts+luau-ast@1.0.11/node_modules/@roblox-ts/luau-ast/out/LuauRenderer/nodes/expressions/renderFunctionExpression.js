"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderFunctionExpression = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const renderParameters_1 = require("../../util/renderParameters");
const renderStatements_1 = require("../../util/renderStatements");
function renderFunctionExpression(state, node) {
    if (LuauAST_1.default.list.isEmpty(node.statements)) {
        return `function(${(0, renderParameters_1.renderParameters)(state, node)}) end`;
    }
    let result = "";
    result += state.newline(`function(${(0, renderParameters_1.renderParameters)(state, node)})`);
    result += state.block(() => (0, renderStatements_1.renderStatements)(state, node.statements));
    result += state.indented(`end`);
    return result;
}
exports.renderFunctionExpression = renderFunctionExpression;
//# sourceMappingURL=renderFunctionExpression.js.map