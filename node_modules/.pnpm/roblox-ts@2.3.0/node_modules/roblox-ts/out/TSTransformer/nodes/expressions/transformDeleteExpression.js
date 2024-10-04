"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformDeleteExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("./transformExpression");
const isUsedAsStatement_1 = require("../../util/isUsedAsStatement");
function transformDeleteExpression(state, node) {
    (0, transformExpression_1.transformExpression)(state, node.expression);
    return !(0, isUsedAsStatement_1.isUsedAsStatement)(node) ? luau_ast_1.default.bool(true) : luau_ast_1.default.none();
}
exports.transformDeleteExpression = transformDeleteExpression;
//# sourceMappingURL=transformDeleteExpression.js.map