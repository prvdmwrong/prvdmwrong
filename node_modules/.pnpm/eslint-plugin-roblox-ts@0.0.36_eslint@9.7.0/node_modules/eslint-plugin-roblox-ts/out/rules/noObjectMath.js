"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.noObjectMath = exports.noObjectMathName = void 0;
const rules_1 = require("../util/rules");
const dataTypes = ["CFrame", "UDim", "UDim2", "Vector2", "Vector2int16", "Vector3", "Vector3int16"];
const mathOperationSymbolsToMacroNames = new Map([
    ["+", "add"],
    ["-", "sub"],
    ["*", "mul"],
    ["/", "div"],
]);
const safeOperationSymbols = new Set(["===", "!=="]);
exports.noObjectMathName = "no-object-math";
exports.noObjectMath = (0, rules_1.makeRule)({
    name: exports.noObjectMathName,
    meta: {
        type: "problem",
        docs: {
            description: "Bans math operators from being used on data types",
            recommended: "error",
            requiresTypeChecking: true,
        },
        fixable: "code",
        messages: {
            addViolation: "Do not use `+` use .add() instead.",
            subViolation: "Do not use `-` use .sub() instead.",
            mulViolation: "Do not use `*` use .mul() instead.",
            divViolation: "Do not use `/` use .div() instead.",
            otherViolation: "Cannot use this operator on a Roblox Data type.",
        },
        schema: [],
    },
    defaultOptions: [],
    create(context) {
        const service = (0, rules_1.getParserServices)(context);
        const checker = service.program.getTypeChecker();
        return {
            BinaryExpression(node) {
                const { left, right } = node;
                const tsNode = service.esTreeNodeToTSNodeMap.get(left);
                const type = (0, rules_1.getConstrainedTypeAtLocation)(checker, tsNode);
                const symbol = type.getSymbol();
                if (symbol && dataTypes.includes(symbol.getName())) {
                    const macroName = mathOperationSymbolsToMacroNames.get(node.operator);
                    if (macroName) {
                        return context.report({
                            node,
                            messageId: `${macroName}Violation`,
                            fix: fix => [
                                fix.replaceTextRange([left.range[1], right.range[0]], `.${macroName}(`),
                                fix.insertTextAfter(right, ")"),
                            ],
                        });
                    }
                    else if (!safeOperationSymbols.has(node.operator)) {
                        return context.report({
                            node,
                            messageId: "otherViolation",
                        });
                    }
                }
            },
        };
    },
});
