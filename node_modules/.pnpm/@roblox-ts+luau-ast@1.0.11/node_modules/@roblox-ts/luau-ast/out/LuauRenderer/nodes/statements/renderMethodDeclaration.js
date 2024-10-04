"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderMethodDeclaration = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
const renderParameters_1 = require("../../util/renderParameters");
const renderStatements_1 = require("../../util/renderStatements");
function renderMethodDeclaration(state, node) {
    let result = "";
    result += state.line(`function ${(0, LuauRenderer_1.render)(state, node.expression)}:${node.name}(${(0, renderParameters_1.renderParameters)(state, node)})`);
    result += state.block(() => (0, renderStatements_1.renderStatements)(state, node.statements));
    result += state.line(`end`);
    return result;
}
exports.renderMethodDeclaration = renderMethodDeclaration;
//# sourceMappingURL=renderMethodDeclaration.js.map