"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderVariableDeclaration = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const assert_1 = require("../../../LuauAST/util/assert");
const LuauRenderer_1 = require("../..");
function renderVariableDeclaration(state, node) {
    let leftStr;
    if (LuauAST_1.default.list.isList(node.left)) {
        (0, assert_1.assert)(!LuauAST_1.default.list.isEmpty(node.left));
        leftStr = LuauAST_1.default.list.mapToArray(node.left, id => (0, LuauRenderer_1.render)(state, id)).join(", ");
    }
    else {
        leftStr = (0, LuauRenderer_1.render)(state, node.left);
    }
    if (node.right) {
        let rightStr;
        if (LuauAST_1.default.list.isList(node.right)) {
            (0, assert_1.assert)(!LuauAST_1.default.list.isEmpty(node.right));
            rightStr = LuauAST_1.default.list.mapToArray(node.right, expression => (0, LuauRenderer_1.render)(state, expression)).join(", ");
        }
        else {
            rightStr = (0, LuauRenderer_1.render)(state, node.right);
        }
        return state.line(`local ${leftStr} = ${rightStr}`, node);
    }
    else {
        return state.line(`local ${leftStr}`, node);
    }
}
exports.renderVariableDeclaration = renderVariableDeclaration;
//# sourceMappingURL=renderVariableDeclaration.js.map