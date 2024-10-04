"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.noPrecedingSpreadElement = exports.noPrecedingSpreadElementName = void 0;
const typescript_1 = __importDefault(require("typescript"));
const rules_1 = require("../util/rules");
exports.noPrecedingSpreadElementName = "no-preceding-spread-element";
exports.noPrecedingSpreadElement = (0, rules_1.makeRule)({
    name: exports.noPrecedingSpreadElementName,
    meta: {
        type: "problem",
        docs: {
            description: "Bans spread elements not last in a list of arguments from being used",
            recommended: "error",
            requiresTypeChecking: false,
        },
        schema: [],
        messages: {
            noPrecedingSpreadElementViolation: "Spread element must come last in a list of arguments!",
        },
    },
    defaultOptions: [],
    create(context) {
        const service = (0, rules_1.getParserServices)(context);
        return {
            SpreadElement(node) {
                const tsNode = service.esTreeNodeToTSNodeMap.get(node);
                const parent = tsNode.parent;
                if (!typescript_1.default.isArrayLiteralExpression(parent) && !typescript_1.default.isObjectLiteralExpression(parent)) {
                    if (parent.arguments) {
                        if (parent.arguments[parent.arguments.length - 1] !== tsNode) {
                            context.report({
                                node: node,
                                messageId: "noPrecedingSpreadElementViolation",
                            });
                        }
                    }
                }
            },
        };
    },
});
