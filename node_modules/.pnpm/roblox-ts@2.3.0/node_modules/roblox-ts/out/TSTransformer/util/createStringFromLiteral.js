"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createStringFromLiteral = void 0;
const typescript_1 = __importDefault(require("typescript"));
const TEMPLATE_EDGE = "`".length;
const TEMPLATE_EXP_START = "${".length;
const TEMPLATE_EXP_END = "}".length;
function createStringFromLiteral(node) {
    let text = node.getText();
    if (typescript_1.default.isStringLiteral(node) || typescript_1.default.isNoSubstitutionTemplateLiteral(node)) {
        text = typescript_1.default.stripQuotes(text);
    }
    else if (typescript_1.default.isTemplateHead(node)) {
        text = text.slice(TEMPLATE_EDGE, -TEMPLATE_EXP_START);
    }
    else if (typescript_1.default.isTemplateMiddle(node)) {
        text = text.slice(TEMPLATE_EXP_END, -TEMPLATE_EXP_START);
    }
    else if (typescript_1.default.isTemplateTail(node)) {
        text = text.slice(TEMPLATE_EXP_END, -TEMPLATE_EDGE);
    }
    return text;
}
exports.createStringFromLiteral = createStringFromLiteral;
//# sourceMappingURL=createStringFromLiteral.js.map