"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderIfStatement = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
const renderStatements_1 = require("../../util/renderStatements");
function renderIfStatement(state, node) {
    let result = "";
    result += state.line(`if ${(0, LuauRenderer_1.render)(state, node.condition)} then`);
    result += state.block(() => (0, renderStatements_1.renderStatements)(state, node.statements));
    let currentElseBody = node.elseBody;
    while (LuauAST_1.default.isNode(currentElseBody)) {
        const statements = currentElseBody.statements;
        result += state.line(`elseif ${(0, LuauRenderer_1.render)(state, currentElseBody.condition)} then`);
        result += state.block(() => (0, renderStatements_1.renderStatements)(state, statements));
        currentElseBody = currentElseBody.elseBody;
    }
    if (currentElseBody && LuauAST_1.default.list.isNonEmpty(currentElseBody)) {
        result += state.line(`else`);
        const statements = currentElseBody;
        result += state.block(() => (0, renderStatements_1.renderStatements)(state, statements));
    }
    result += state.line(`end`);
    return result;
}
exports.renderIfStatement = renderIfStatement;
//# sourceMappingURL=renderIfStatement.js.map