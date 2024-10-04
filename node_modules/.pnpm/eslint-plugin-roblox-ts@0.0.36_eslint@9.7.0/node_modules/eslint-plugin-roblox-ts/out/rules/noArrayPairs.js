"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.noArrayPairs = exports.noArrayPairsName = void 0;
const rules_1 = require("../util/rules");
const types_1 = require("../util/types");
function makeViolationText(name) {
    return `Do not use Array<T> with ${name}(). Key values will not be shifted from 1-indexed to 0-indexed.`;
}
exports.noArrayPairsName = "no-array-pairs";
exports.noArrayPairs = (0, rules_1.makeRule)({
    name: exports.noArrayPairsName,
    meta: {
        type: "problem",
        docs: {
            description: "Disallows usage of pairs() and ipairs() with Array<T>",
            recommended: "warn",
            requiresTypeChecking: true,
        },
        schema: [],
        messages: {
            arrayPairsViolation: makeViolationText("pairs"),
            arrayIPairsViolation: makeViolationText("ipairs"),
        },
    },
    defaultOptions: [],
    create(context) {
        const service = (0, rules_1.getParserServices)(context);
        const checker = service.program.getTypeChecker();
        return {
            CallExpression(esNode) {
                const tsNode = service.esTreeNodeToTSNodeMap.get(esNode);
                const expressionName = tsNode.expression.getText();
                if (expressionName === "pairs" || expressionName === "ipairs") {
                    const argType = (0, types_1.getType)(checker, tsNode.arguments[0]);
                    if ((0, types_1.isPossiblyType)(argType, t => (0, types_1.isArrayType)(checker, t))) {
                        if (expressionName === "pairs") {
                            context.report({
                                node: esNode,
                                messageId: "arrayPairsViolation",
                            });
                        }
                        else {
                            context.report({
                                node: esNode,
                                messageId: "arrayIPairsViolation",
                            });
                        }
                    }
                    else {
                    }
                }
            },
        };
    },
});
