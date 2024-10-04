"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.noGlobalThis = exports.noGlobalThisName = void 0;
const rules_1 = require("../util/rules");
exports.noGlobalThisName = "no-global-this";
exports.noGlobalThis = (0, rules_1.makeRule)({
    name: exports.noGlobalThisName,
    meta: {
        type: "problem",
        docs: {
            description: "Bans globalThis from being used",
            recommended: "error",
            requiresTypeChecking: false,
        },
        messages: {
            globalThisViolation: "`globalThis` is not supported!",
        },
        schema: [],
    },
    defaultOptions: [],
    create(context) {
        return {
            Identifier(node) {
                if (node.name === "globalThis") {
                    context.report({
                        node: node,
                        messageId: "globalThisViolation",
                    });
                }
            },
        };
    },
});
