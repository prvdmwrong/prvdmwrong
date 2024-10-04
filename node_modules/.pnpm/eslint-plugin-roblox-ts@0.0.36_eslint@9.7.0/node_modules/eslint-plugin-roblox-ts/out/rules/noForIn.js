"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.noForIn = exports.noForInName = void 0;
const rules_1 = require("../util/rules");
exports.noForInName = "no-for-in";
exports.noForIn = (0, rules_1.makeRule)({
    name: exports.noForInName,
    meta: {
        type: "problem",
        docs: {
            description: "Disallows iterating with a for-in loop",
            recommended: "error",
            requiresTypeChecking: false,
        },
        messages: {
            forInViolation: "For-in loops are forbidden because it always types the iterator variable as `string`. Use for-of or array.forEach instead.",
        },
        schema: [],
        fixable: "code",
    },
    defaultOptions: [],
    create(context) {
        return {
            ForInStatement(node) {
                context.report({
                    node,
                    messageId: "forInViolation",
                    fix: fix => fix.replaceTextRange([node.left.range[1], node.right.range[0]], " of "),
                });
            },
        };
    },
});
