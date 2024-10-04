"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformTaggedTemplateExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("./transformExpression");
const convertToIndexableExpression_1 = require("../../util/convertToIndexableExpression");
const ensureTransformOrder_1 = require("../../util/ensureTransformOrder");
const typescript_1 = __importDefault(require("typescript"));
function transformTaggedTemplateExpression(state, node) {
    const tagExp = (0, transformExpression_1.transformExpression)(state, node.tag);
    if (typescript_1.default.isTemplateExpression(node.template)) {
        const strings = new Array();
        strings.push(luau_ast_1.default.string(node.template.head.text));
        for (const templateSpan of node.template.templateSpans) {
            strings.push(luau_ast_1.default.string(templateSpan.literal.text));
        }
        const expressions = (0, ensureTransformOrder_1.ensureTransformOrder)(state, node.template.templateSpans.map(templateSpan => templateSpan.expression));
        return luau_ast_1.default.call((0, convertToIndexableExpression_1.convertToIndexableExpression)(tagExp), [luau_ast_1.default.array(strings), ...expressions]);
    }
    else {
        return luau_ast_1.default.call((0, convertToIndexableExpression_1.convertToIndexableExpression)(tagExp), [luau_ast_1.default.array([luau_ast_1.default.string(node.template.text)])]);
    }
}
exports.transformTaggedTemplateExpression = transformTaggedTemplateExpression;
//# sourceMappingURL=transformTaggedTemplateExpression.js.map