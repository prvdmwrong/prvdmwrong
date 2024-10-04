"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.noSpreadDestructuring = exports.noSpreadDestructuringName = void 0;
const rules_1 = require("../util/rules");
exports.noSpreadDestructuringName = "no-spread-destructuring";
exports.noSpreadDestructuring = (0, rules_1.makeRule)({
    name: exports.noSpreadDestructuringName,
    meta: {
        type: "problem",
        docs: {
            description: "Bans spread destructuring from being used",
            recommended: "error",
            requiresTypeChecking: false,
        },
        messages: {
            spreadDestructuringViolation: "Operator `...` is not supported for destructuring!",
        },
        schema: [],
    },
    defaultOptions: [],
    create(context) {
        return {
            ArrayPattern(node) {
                node.elements.forEach(element => {
                    if ((element === null || element === void 0 ? void 0 : element.type) == "RestElement") {
                        context.report({
                            node: node,
                            messageId: "spreadDestructuringViolation",
                        });
                    }
                });
            },
        };
    },
});
