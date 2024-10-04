"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderMethodCallExpression = void 0;
const LuauAST_1 = __importDefault(require("../../../../LuauAST"));
const assert_1 = require("../../../../LuauAST/util/assert");
const LuauRenderer_1 = require("../../..");
const renderArguments_1 = require("../../../util/renderArguments");
function renderMethodCallExpression(state, node) {
    (0, assert_1.assert)(LuauAST_1.default.isValidIdentifier(node.name));
    return `${(0, LuauRenderer_1.render)(state, node.expression)}:${node.name}(${(0, renderArguments_1.renderArguments)(state, node.args)})`;
}
exports.renderMethodCallExpression = renderMethodCallExpression;
//# sourceMappingURL=renderMethodCallExpression.js.map