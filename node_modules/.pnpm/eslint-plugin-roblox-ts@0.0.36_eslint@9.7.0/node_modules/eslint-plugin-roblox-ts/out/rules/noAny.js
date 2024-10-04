"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.noAny = exports.noAnyName = void 0;
const typescript_1 = __importDefault(require("typescript"));
const rules_1 = require("../util/rules");
const traversal_1 = require("../util/traversal");
const types_1 = require("../util/types");
exports.noAnyName = "no-any";
exports.noAny = (0, rules_1.makeRule)({
    name: exports.noAnyName,
    meta: {
        type: "problem",
        docs: {
            description: "Bans prototype from being used",
            recommended: "error",
            requiresTypeChecking: true,
        },
        messages: {
            anyViolation: "Using values of type `any` is not supported! Use `unknown` instead.",
        },
        schema: [],
    },
    defaultOptions: [],
    create(context) {
        function validateNotAnyType(checker, esNode, tsNode) {
            if (typescript_1.default.isSpreadElement(tsNode)) {
                tsNode = (0, traversal_1.skipDownwards)(tsNode.expression);
            }
            let type = (0, types_1.getType)(checker, tsNode);
            if ((0, types_1.isDefinitelyType)(type, t => (0, types_1.isArrayType)(checker, t))) {
                // Array<T> -> T
                const typeArguments = (0, types_1.getTypeArguments)(checker, type);
                if (typeArguments.length > 0) {
                    type = typeArguments[0];
                }
            }
            if ((0, types_1.isAnyType)(type)) {
                context.report({
                    messageId: "anyViolation",
                    node: esNode,
                });
            }
        }
        return {
            BinaryExpression(esNode) {
                const service = (0, rules_1.getParserServices)(context);
                const checker = service.program.getTypeChecker();
                const tsNode = service.esTreeNodeToTSNodeMap.get(esNode);
                validateNotAnyType(checker, esNode.left, tsNode.left);
                validateNotAnyType(checker, esNode.right, tsNode.right);
            },
            UnaryExpression(esNode) {
                const service = (0, rules_1.getParserServices)(context);
                const checker = service.program.getTypeChecker();
                const tsNode = service.esTreeNodeToTSNodeMap.get(esNode);
                if (typescript_1.default.isPrefixUnaryExpression(tsNode) || typescript_1.default.isPostfixUnaryExpression(tsNode)) {
                    validateNotAnyType(checker, esNode.argument, tsNode.operand);
                }
            },
            CallExpression(esNode) {
                const service = (0, rules_1.getParserServices)(context);
                const checker = service.program.getTypeChecker();
                validateNotAnyType(checker, esNode.callee, service.esTreeNodeToTSNodeMap.get(esNode).expression);
            },
            NewExpression(esNode) {
                const service = (0, rules_1.getParserServices)(context);
                const checker = service.program.getTypeChecker();
                validateNotAnyType(checker, esNode.callee, service.esTreeNodeToTSNodeMap.get(esNode).expression);
            },
            SpreadElement(esNode) {
                const service = (0, rules_1.getParserServices)(context);
                const checker = service.program.getTypeChecker();
                validateNotAnyType(checker, esNode.argument, service.esTreeNodeToTSNodeMap.get(esNode).expression);
            },
            MemberExpression(esNode) {
                const service = (0, rules_1.getParserServices)(context);
                const checker = service.program.getTypeChecker();
                const tsNode = service.esTreeNodeToTSNodeMap.get(esNode);
                validateNotAnyType(checker, esNode.object, tsNode.expression);
                if (typescript_1.default.isElementAccessExpression(tsNode)) {
                    validateNotAnyType(checker, esNode.property, tsNode.argumentExpression);
                }
            },
        };
    },
});
