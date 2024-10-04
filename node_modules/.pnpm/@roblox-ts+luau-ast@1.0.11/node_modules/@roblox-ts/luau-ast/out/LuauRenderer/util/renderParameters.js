"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderParameters = void 0;
const LuauAST_1 = __importDefault(require("../../LuauAST"));
const LuauRenderer_1 = require("..");
function renderParameters(state, node) {
    const paramStrs = LuauAST_1.default.list.mapToArray(node.parameters, param => (0, LuauRenderer_1.render)(state, param));
    if (node.hasDotDotDot) {
        paramStrs.push("...");
    }
    return paramStrs.join(", ");
}
exports.renderParameters = renderParameters;
//# sourceMappingURL=renderParameters.js.map