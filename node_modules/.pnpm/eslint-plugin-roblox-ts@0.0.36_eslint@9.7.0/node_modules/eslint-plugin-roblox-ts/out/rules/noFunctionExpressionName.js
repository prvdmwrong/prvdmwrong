"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.noFunctionExpressionId = exports.noFunctionExpressionIdName = void 0;
const rules_1 = require("../util/rules");
exports.noFunctionExpressionIdName = "no-function-expression-id";
exports.noFunctionExpressionId = (0, rules_1.makeRule)({
    name: exports.noFunctionExpressionIdName,
    meta: {
        type: "problem",
        docs: {
            description: "Bans function expression names",
            recommended: "error",
            requiresTypeChecking: false,
        },
        messages: {
            functionExpressionIdViolation: "Function expression names are not supported!",
        },
        schema: [],
        fixable: "code",
    },
    defaultOptions: [],
    create(context) {
        return {
            FunctionExpression(node) {
                if (node.id) {
                    context.report({
                        node: node.id,
                        messageId: "functionExpressionIdViolation",
                        fix: fix => node.id && fix.removeRange(node.id.range),
                    });
                }
            },
        };
    },
});
