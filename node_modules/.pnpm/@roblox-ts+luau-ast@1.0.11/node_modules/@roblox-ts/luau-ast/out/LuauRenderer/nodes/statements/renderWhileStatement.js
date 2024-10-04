"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderWhileStatement = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
const renderStatements_1 = require("../../util/renderStatements");
function renderWhileStatement(state, node) {
    let result = "";
    result += state.line(`while ${(0, LuauRenderer_1.render)(state, node.condition)} do`);
    result += state.block(() => (0, renderStatements_1.renderStatements)(state, node.statements));
    result += state.line(`end`);
    return result;
}
exports.renderWhileStatement = renderWhileStatement;
//# sourceMappingURL=renderWhileStatement.js.map