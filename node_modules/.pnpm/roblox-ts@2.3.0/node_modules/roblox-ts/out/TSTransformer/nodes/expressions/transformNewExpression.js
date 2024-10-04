"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformNewExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("./transformExpression");
const convertToIndexableExpression_1 = require("../../util/convertToIndexableExpression");
const ensureTransformOrder_1 = require("../../util/ensureTransformOrder");
const types_1 = require("../../util/types");
const validateNotAny_1 = require("../../util/validateNotAny");
function transformNewExpression(state, node) {
    (0, validateNotAny_1.validateNotAnyType)(state, node.expression);
    const symbol = (0, types_1.getFirstConstructSymbol)(state, node.expression);
    if (symbol) {
        const macro = state.services.macroManager.getConstructorMacro(symbol);
        if (macro) {
            return macro(state, node);
        }
    }
    const expression = (0, convertToIndexableExpression_1.convertToIndexableExpression)((0, transformExpression_1.transformExpression)(state, node.expression));
    const args = node.arguments ? (0, ensureTransformOrder_1.ensureTransformOrder)(state, node.arguments) : [];
    return luau_ast_1.default.call(luau_ast_1.default.property(expression, "new"), args);
}
exports.transformNewExpression = transformNewExpression;
//# sourceMappingURL=transformNewExpression.js.map