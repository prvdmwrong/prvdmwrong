"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.noValueTypeOf = exports.noValueTypeOfName = void 0;
const rules_1 = require("../util/rules");
exports.noValueTypeOfName = "no-value-typeof";
exports.noValueTypeOf = (0, rules_1.makeRule)({
    name: "no-value-typeof",
    meta: {
        type: "problem",
        docs: {
            description: "Disallows the typeof operator for values",
            recommended: "error",
            requiresTypeChecking: false,
        },
        schema: [],
        messages: {
            typeofValueViolation: "'typeof' operator is not supported! Use `typeIs(value, type)` or `typeOf(value)` instead.",
        },
    },
    defaultOptions: [],
    create(context) {
        return {
            UnaryExpression(node) {
                if (node.operator === "typeof") {
                    context.report({ node, messageId: "typeofValueViolation" });
                }
            },
        };
    },
});
