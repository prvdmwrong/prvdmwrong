"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.noGettersOrSetters = exports.noGettersOrSettersName = void 0;
const rules_1 = require("../util/rules");
exports.noGettersOrSettersName = "no-getters-or-setters";
exports.noGettersOrSetters = (0, rules_1.makeRule)({
    name: exports.noGettersOrSettersName,
    meta: {
        type: "problem",
        docs: {
            description: "Disallows getters and setters",
            recommended: "error",
            requiresTypeChecking: false,
        },
        schema: [],
        messages: {
            getterSetterViolation: "Getters and Setters are not supported for performance reasons. Please use a normal method instead.",
        },
        fixable: "code",
    },
    defaultOptions: [],
    create(context) {
        const checkMethodDefinition = (fields) => {
            for (const node of fields) {
                if ("kind" in node && (node.kind === "get" || node.kind === "set")) {
                    context.report({
                        node,
                        messageId: "getterSetterViolation",
                        fix: fix => fix.removeRange([node.key.range[0] - 1, node.key.range[0]]),
                    });
                }
            }
        };
        return {
            ObjectExpression: node => checkMethodDefinition(node.properties),
            ClassBody: node => checkMethodDefinition(node.body),
        };
    },
});
