"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderStatements = void 0;
const LuauAST_1 = __importDefault(require("../../LuauAST"));
const assert_1 = require("../../LuauAST/util/assert");
const LuauRenderer_1 = require("..");
function renderStatements(state, statements) {
    let result = "";
    let listNode = statements.head;
    let hasFinalStatement = false;
    while (listNode !== undefined) {
        (0, assert_1.assert)(!hasFinalStatement || LuauAST_1.default.isComment(listNode.value), "Cannot render statement after break, continue, or return!");
        hasFinalStatement || (hasFinalStatement = LuauAST_1.default.isFinalStatement(listNode.value));
        state.pushListNode(listNode);
        result += (0, LuauRenderer_1.render)(state, listNode.value);
        state.popListNode();
        listNode = listNode.next;
    }
    return result;
}
exports.renderStatements = renderStatements;
//# sourceMappingURL=renderStatements.js.map