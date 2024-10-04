"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderStringLiteral = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const getSafeBracketEquals_1 = require("../../util/getSafeBracketEquals");
function needsBracketSpacing(node) {
    const parent = node.parent;
    if (!parent) {
        return false;
    }
    if (LuauAST_1.default.isMapField(parent) && node === parent.index) {
        return true;
    }
    if (LuauAST_1.default.isComputedIndexExpression(parent) && node === parent.index) {
        return true;
    }
    if (LuauAST_1.default.isSet(parent)) {
        return true;
    }
    return false;
}
function renderStringLiteral(state, node) {
    const isMultiline = node.value.includes("\n");
    if (!isMultiline && !node.value.includes('"')) {
        return `"${node.value}"`;
    }
    else if (!isMultiline && !node.value.includes("'")) {
        return `'${node.value}'`;
    }
    else {
        const eqStr = (0, getSafeBracketEquals_1.getSafeBracketEquals)(node.value);
        const spacing = needsBracketSpacing(node) ? " " : "";
        return `${spacing}[${eqStr}[${node.value}]${eqStr}]${spacing}`;
    }
}
exports.renderStringLiteral = renderStringLiteral;
//# sourceMappingURL=renderStringLiteral.js.map