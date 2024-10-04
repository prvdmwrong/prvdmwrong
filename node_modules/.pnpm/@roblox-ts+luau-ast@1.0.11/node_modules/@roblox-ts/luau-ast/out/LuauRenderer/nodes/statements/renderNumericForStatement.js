"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderNumericForStatement = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
const renderStatements_1 = require("../../util/renderStatements");
function renderNumericForStatement(state, node) {
    const idStr = (0, LuauRenderer_1.render)(state, node.id);
    const startStr = (0, LuauRenderer_1.render)(state, node.start);
    const endStr = (0, LuauRenderer_1.render)(state, node.end);
    let predicateStr = `${startStr}, ${endStr}`;
    if (node.step && (!LuauAST_1.default.isNumberLiteral(node.step) || Number(node.step.value) !== 1)) {
        const stepStr = (0, LuauRenderer_1.render)(state, node.step);
        predicateStr += `, ${stepStr}`;
    }
    let result = "";
    result += state.line(`for ${idStr} = ${predicateStr} do`);
    result += state.block(() => (0, renderStatements_1.renderStatements)(state, node.statements));
    result += state.line(`end`);
    return result;
}
exports.renderNumericForStatement = renderNumericForStatement;
//# sourceMappingURL=renderNumericForStatement.js.map