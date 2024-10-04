"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.misleadingLuatupleChecks = exports.misleadingLuatupleChecksName = void 0;
const experimental_utils_1 = require("@typescript-eslint/experimental-utils");
const rules_1 = require("../util/rules");
exports.misleadingLuatupleChecksName = "misleading-luatuple-checks";
exports.misleadingLuatupleChecks = (0, rules_1.makeRule)({
    name: exports.misleadingLuatupleChecksName,
    meta: {
        type: "problem",
        docs: {
            description: "Bans LuaTuples boolean expressions",
            recommended: "error",
            requiresTypeChecking: true,
        },
        schema: [],
        messages: {
            bannedLuaTupleCheck: "Unexpected LuaTuple in conditional expression. Add [0].",
        },
        fixable: "code",
    },
    defaultOptions: [],
    create(context) {
        const service = (0, rules_1.getParserServices)(context);
        const checker = service.program.getTypeChecker();
        function checkTruthy(node) {
            const { aliasSymbol } = (0, rules_1.getConstrainedType)(service, checker, node);
            if (aliasSymbol && aliasSymbol.escapedName === "LuaTuple")
                context.report({
                    node,
                    messageId: "bannedLuaTupleCheck",
                    fix: fix => fix.insertTextAfter(node, "[0]"),
                });
        }
        /**
         * Asserts that a testable expression contains a boolean, reports otherwise.
         * Filters all LogicalExpressions to prevent some duplicate reports.
         */
        const containsBoolean = ({ test }) => {
            if (test && test.type !== experimental_utils_1.AST_NODE_TYPES.LogicalExpression)
                checkTruthy(test);
        };
        return {
            ConditionalExpression: containsBoolean,
            DoWhileStatement: containsBoolean,
            ForStatement: containsBoolean,
            IfStatement: containsBoolean,
            WhileStatement: containsBoolean,
            LogicalExpression: ({ left, right }) => {
                checkTruthy(left);
                checkTruthy(right);
            },
            'UnaryExpression[operator="!"]': ({ argument }) => checkTruthy(argument),
        };
    },
});
