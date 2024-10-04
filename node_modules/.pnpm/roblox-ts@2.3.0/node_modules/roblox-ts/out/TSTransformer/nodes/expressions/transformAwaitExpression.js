"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformAwaitExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("./transformExpression");
const traversal_1 = require("../../util/traversal");
function transformAwaitExpression(state, node) {
    return luau_ast_1.default.call(state.TS(node, "await"), [(0, transformExpression_1.transformExpression)(state, (0, traversal_1.skipDownwards)(node.expression))]);
}
exports.transformAwaitExpression = transformAwaitExpression;
//# sourceMappingURL=transformAwaitExpression.js.map