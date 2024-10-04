"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.RenderState = void 0;
const LuauAST_1 = __importDefault(require("../LuauAST"));
const assert_1 = require("../LuauAST/util/assert");
const getEnding_1 = require("./util/getEnding");
const getOrSetDefault_1 = require("./util/getOrSetDefault");
const INDENT_CHARACTER = "\t";
const INDENT_CHARACTER_LENGTH = INDENT_CHARACTER.length;
class RenderState {
    constructor() {
        this.indent = "";
        this.seenTempNodes = new Map();
        this.listNodesStack = new Array();
        this.tempIdFallback = 0;
    }
    pushIndent() {
        this.indent += INDENT_CHARACTER;
    }
    popIndent() {
        this.indent = this.indent.substr(INDENT_CHARACTER_LENGTH);
    }
    getTempName(node) {
        const name = (0, getOrSetDefault_1.getOrSetDefault)(this.seenTempNodes, node.id, () => `_${this.tempIdFallback++}`);
        (0, assert_1.assert)(name);
        return name;
    }
    pushListNode(listNode) {
        this.listNodesStack.push(listNode);
    }
    peekListNode() {
        return this.listNodesStack[this.listNodesStack.length - 1];
    }
    popListNode() {
        return this.listNodesStack.pop();
    }
    newline(text) {
        return text + "\n";
    }
    indented(text) {
        return this.indent + text;
    }
    line(text, endNode) {
        let result = this.indented(text);
        if (endNode) {
            result += (0, getEnding_1.getEnding)(this, endNode);
        }
        result = this.newline(result);
        return result;
    }
    block(callback) {
        this.pushIndent();
        const result = callback();
        this.popIndent();
        return result;
    }
}
exports.RenderState = RenderState;
//# sourceMappingURL=RenderState.js.map