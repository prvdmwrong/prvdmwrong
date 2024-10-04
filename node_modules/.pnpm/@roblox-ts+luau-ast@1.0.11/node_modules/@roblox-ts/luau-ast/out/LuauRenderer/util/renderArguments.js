"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderArguments = void 0;
const LuauAST_1 = __importDefault(require("../../LuauAST"));
const LuauRenderer_1 = require("..");
function renderArguments(state, expressions) {
    return LuauAST_1.default.list.mapToArray(expressions, v => (0, LuauRenderer_1.render)(state, v)).join(", ");
}
exports.renderArguments = renderArguments;
//# sourceMappingURL=renderArguments.js.map