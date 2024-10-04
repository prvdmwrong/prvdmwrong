"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.noPrivateIdentifier = exports.noPrivateIdentifierName = void 0;
const typescript_1 = __importDefault(require("typescript"));
const rules_1 = require("../util/rules");
exports.noPrivateIdentifierName = "no-private-identifier";
exports.noPrivateIdentifier = (0, rules_1.makeRule)({
    name: exports.noPrivateIdentifierName,
    meta: {
        type: "problem",
        docs: {
            description: "Bans private identifiers from being used",
            recommended: "error",
            requiresTypeChecking: false,
        },
        fixable: "code",
        messages: {
            privateIdentifierViolation: "Private identifiers are not supported!",
        },
        schema: [],
    },
    defaultOptions: [],
    create(context) {
        const service = (0, rules_1.getParserServices)(context);
        return {
            PropertyDefinition(node) {
                const tsNode = service.esTreeNodeToTSNodeMap.get(node.key);
                if (typescript_1.default.isPrivateIdentifier(tsNode)) {
                    context.report({
                        node: node,
                        messageId: "privateIdentifierViolation",
                        fix: fixer => fixer.replaceText(node.key, `private ${tsNode.escapedText.toString().substring(1)}`),
                    });
                }
            },
        };
    },
});
