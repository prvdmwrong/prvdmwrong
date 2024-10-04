"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.noRbxPostFixNew = exports.noRbxPostFixNewName = void 0;
const typescript_1 = __importDefault(require("typescript"));
const rules_1 = require("../util/rules");
const dataTypes = [
    "CFrameConstructor",
    "UDimConstructor",
    "UDim2Constructor",
    "Vector2Constructor",
    "Vector2int16Constructor",
    "Vector3Constructor",
    "Vector3int16Constructor",
];
exports.noRbxPostFixNewName = "no-rbx-postfix-new";
exports.noRbxPostFixNew = (0, rules_1.makeRule)({
    name: exports.noRbxPostFixNewName,
    meta: {
        type: "problem",
        docs: {
            description: "Bans calling .new() on Roblox objects (helps transition to TS)",
            recommended: "error",
            requiresTypeChecking: true,
        },
        fixable: "code",
        messages: {
            newViolation: "Do not use `.new` use `new X()` instead.",
        },
        schema: [],
    },
    defaultOptions: [],
    create(context) {
        const service = (0, rules_1.getParserServices)(context);
        const checker = service.program.getTypeChecker();
        return {
            CallExpression(node) {
                const propertyAccess = service.esTreeNodeToTSNodeMap.get(node.callee);
                if (typescript_1.default.isPropertyAccessExpression(propertyAccess)) {
                    const type = (0, rules_1.getConstrainedTypeAtLocation)(checker, propertyAccess.expression);
                    const symbol = type.getSymbol();
                    if (symbol && dataTypes.includes(symbol.getName()) && propertyAccess.name.text === "new") {
                        return context.report({
                            node,
                            messageId: "newViolation",
                            fix: fix => [
                                fix.removeRange([node.callee.range[1] - 4, node.callee.range[1]]),
                                fix.insertTextBefore(node, "new "),
                            ],
                        });
                    }
                }
            },
        };
    },
});
