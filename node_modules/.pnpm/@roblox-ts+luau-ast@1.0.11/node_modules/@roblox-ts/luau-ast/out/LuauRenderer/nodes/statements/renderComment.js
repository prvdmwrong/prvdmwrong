"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderComment = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const getSafeBracketEquals_1 = require("../../util/getSafeBracketEquals");
function renderComment(state, node) {
    const lines = node.text.split("\n");
    if (lines.length > 1) {
        const eqStr = (0, getSafeBracketEquals_1.getSafeBracketEquals)(node.text);
        let result = state.line(`--[${eqStr}[`);
        result += state.block(() => lines.map(line => state.line(line)).join(""));
        result += state.line(`]${eqStr}]`);
        return result;
    }
    else {
        return lines.map(line => state.line(`--${line}`)).join("");
    }
}
exports.renderComment = renderComment;
//# sourceMappingURL=renderComment.js.map