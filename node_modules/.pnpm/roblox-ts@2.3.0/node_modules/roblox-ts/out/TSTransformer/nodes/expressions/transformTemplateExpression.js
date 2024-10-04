"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformTemplateExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformInterpolatedStringPart_1 = require("../transformInterpolatedStringPart");
const ensureTransformOrder_1 = require("../../util/ensureTransformOrder");
function transformTemplateExpression(state, node) {
    const parts = luau_ast_1.default.list.make();
    if (node.head.text.length > 0) {
        luau_ast_1.default.list.push(parts, (0, transformInterpolatedStringPart_1.transformInterpolatedStringPart)(node.head));
    }
    const orderedExpressions = (0, ensureTransformOrder_1.ensureTransformOrder)(state, node.templateSpans.map(templateSpan => templateSpan.expression));
    for (let i = 0; i < node.templateSpans.length; i++) {
        luau_ast_1.default.list.push(parts, orderedExpressions[i]);
        const templateSpan = node.templateSpans[i];
        if (templateSpan.literal.text.length > 0) {
            luau_ast_1.default.list.push(parts, (0, transformInterpolatedStringPart_1.transformInterpolatedStringPart)(templateSpan.literal));
        }
    }
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.InterpolatedString, { parts });
}
exports.transformTemplateExpression = transformTemplateExpression;
//# sourceMappingURL=transformTemplateExpression.js.map