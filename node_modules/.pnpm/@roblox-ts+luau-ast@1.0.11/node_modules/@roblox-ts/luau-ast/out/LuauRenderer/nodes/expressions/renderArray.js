"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderArray = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
function renderArray(state, node) {
    if (LuauAST_1.default.list.isEmpty(node.members)) {
        return "{}";
    }
    const membersStr = LuauAST_1.default.list.mapToArray(node.members, member => (0, LuauRenderer_1.render)(state, member)).join(", ");
    return `{ ${membersStr} }`;
}
exports.renderArray = renderArray;
//# sourceMappingURL=renderArray.js.map