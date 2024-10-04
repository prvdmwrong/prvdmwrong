"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.luaTruthiness = exports.luaTruthinessName = void 0;
const experimental_utils_1 = require("@typescript-eslint/experimental-utils");
const rules_1 = require("../util/rules");
const types_1 = require("../util/types");
exports.luaTruthinessName = "lua-truthiness";
exports.luaTruthiness = (0, rules_1.makeRule)({
    name: exports.luaTruthinessName,
    meta: {
        type: "problem",
        docs: {
            description: "Warns against falsy strings and numbers",
            recommended: false,
            requiresTypeChecking: true,
        },
        schema: [],
        messages: {
            falsyStringNumberCheck: '0, NaN, and "" are falsy in TS. If intentional, disable this rule by placing `"roblox-ts/lua-truthiness": "off"` in your .eslintrc file in the "rules" object.',
        },
        fixable: "code",
    },
    defaultOptions: [],
    create(context) {
        const service = (0, rules_1.getParserServices)(context);
        const checker = service.program.getTypeChecker();
        function checkTruthy(node) {
            const type = (0, types_1.getType)(checker, service.esTreeNodeToTSNodeMap.get(node));
            const isAssignableToZero = (0, types_1.isPossiblyType)(type, t => (0, types_1.isNumberLiteralType)(t, 0));
            const isAssignableToNaN = (0, types_1.isPossiblyType)(type, t => (0, types_1.isNaNType)(t));
            const isAssignableToEmptyString = (0, types_1.isPossiblyType)(type, t => (0, types_1.isEmptyStringType)(t));
            if (isAssignableToZero || isAssignableToNaN || isAssignableToEmptyString) {
                context.report({
                    node,
                    messageId: "falsyStringNumberCheck",
                    fix: undefined,
                });
            }
        }
        /**
         * Asserts that a testable expression contains a boolean, reports otherwise.
         * Filters all LogicalExpressions to prevent some duplicate reports.
         */
        const containsBoolean = ({ test }) => {
            if (test && test.type !== experimental_utils_1.AST_NODE_TYPES.LogicalExpression) {
                checkTruthy(test);
            }
        };
        return {
            ConditionalExpression: containsBoolean,
            DoWhileStatement: containsBoolean,
            ForStatement: containsBoolean,
            IfStatement: containsBoolean,
            WhileStatement: containsBoolean,
            LogicalExpression: ({ left, operator }) => operator !== "??" && checkTruthy(left),
            'UnaryExpression[operator="!"]': ({ argument }) => checkTruthy(argument),
        };
    },
});
