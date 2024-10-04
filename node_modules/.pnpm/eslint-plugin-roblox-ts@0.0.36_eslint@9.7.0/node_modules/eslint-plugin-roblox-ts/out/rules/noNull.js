"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.noNull = exports.noNullName = void 0;
const rules_1 = require("../util/rules");
exports.noNullName = "no-null";
exports.noNull = (0, rules_1.makeRule)({
    name: exports.noNullName,
    meta: {
        type: "problem",
        docs: {
            description: "Bans null from being used",
            recommended: "error",
            requiresTypeChecking: false,
        },
        fixable: "code",
        messages: {
            nullViolation: "Do not use null. Use undefined instead",
        },
        schema: [],
    },
    defaultOptions: [],
    create(context) {
        return {
            TSNullKeyword(node) {
                context.report({
                    node: node,
                    messageId: "nullViolation",
                    fix: fixer => fixer.replaceText(node, "undefined"),
                });
            },
            Literal(node) {
                if (node.value === null) {
                    context.report({
                        node: node,
                        messageId: "nullViolation",
                        fix: fixer => fixer.replaceText(node, "undefined"),
                    });
                }
            },
        };
    },
});
