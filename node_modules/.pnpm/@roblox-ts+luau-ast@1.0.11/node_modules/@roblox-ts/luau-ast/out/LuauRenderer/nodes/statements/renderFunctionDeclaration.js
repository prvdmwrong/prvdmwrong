"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderFunctionDeclaration = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const assert_1 = require("../../../LuauAST/util/assert");
const LuauRenderer_1 = require("../..");
const renderParameters_1 = require("../../util/renderParameters");
const renderStatements_1 = require("../../util/renderStatements");
function renderFunctionDeclaration(state, node) {
    if (node.localize) {
        (0, assert_1.assert)(LuauAST_1.default.isAnyIdentifier(node.name), "local function cannot be a property");
    }
    const nameStr = (0, LuauRenderer_1.render)(state, node.name);
    const paramStr = (0, renderParameters_1.renderParameters)(state, node);
    let result = "";
    result += state.line(`${node.localize ? "local " : ""}function ${nameStr}(${paramStr})`);
    result += state.block(() => (0, renderStatements_1.renderStatements)(state, node.statements));
    result += state.line(`end`);
    return result;
}
exports.renderFunctionDeclaration = renderFunctionDeclaration;
//# sourceMappingURL=renderFunctionDeclaration.js.map