"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderDoStatement = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const renderStatements_1 = require("../../util/renderStatements");
function renderDoStatement(state, node) {
    let result = "";
    result += state.line(`do`);
    result += state.block(() => (0, renderStatements_1.renderStatements)(state, node.statements));
    result += state.line(`end`);
    return result;
}
exports.renderDoStatement = renderDoStatement;
//# sourceMappingURL=renderDoStatement.js.map