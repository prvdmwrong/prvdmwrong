"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.visit = void 0;
const LuauAST_1 = __importDefault(require("../../LuauAST"));
const identity_1 = require("./identity");
const NOOP = () => { };
const KIND_TO_VISITOR = (0, identity_1.identity)({
    [LuauAST_1.default.SyntaxKind.Identifier]: NOOP,
    [LuauAST_1.default.SyntaxKind.TemporaryIdentifier]: NOOP,
    [LuauAST_1.default.SyntaxKind.ComputedIndexExpression]: (node, visitor) => {
        visitNode(node.expression, visitor);
        visitNode(node.index, visitor);
    },
    [LuauAST_1.default.SyntaxKind.PropertyAccessExpression]: (node, visitor) => visitNode(node.expression, visitor),
    [LuauAST_1.default.SyntaxKind.CallExpression]: (node, visitor) => {
        visitNode(node.expression, visitor);
        visitList(node.args, visitor);
    },
    [LuauAST_1.default.SyntaxKind.MethodCallExpression]: (node, visitor) => {
        visitNode(node.expression, visitor);
        visitList(node.args, visitor);
    },
    [LuauAST_1.default.SyntaxKind.ParenthesizedExpression]: (node, visitor) => visitNode(node.expression, visitor),
    [LuauAST_1.default.SyntaxKind.None]: NOOP,
    [LuauAST_1.default.SyntaxKind.NilLiteral]: NOOP,
    [LuauAST_1.default.SyntaxKind.FalseLiteral]: NOOP,
    [LuauAST_1.default.SyntaxKind.TrueLiteral]: NOOP,
    [LuauAST_1.default.SyntaxKind.NumberLiteral]: NOOP,
    [LuauAST_1.default.SyntaxKind.StringLiteral]: NOOP,
    [LuauAST_1.default.SyntaxKind.VarArgsLiteral]: NOOP,
    [LuauAST_1.default.SyntaxKind.FunctionExpression]: (node, visitor) => {
        visitList(node.parameters, visitor);
        visitList(node.statements, visitor);
    },
    [LuauAST_1.default.SyntaxKind.BinaryExpression]: (node, visitor) => {
        visitNode(node.left, visitor);
        visitNode(node.right, visitor);
    },
    [LuauAST_1.default.SyntaxKind.UnaryExpression]: (node, visitor) => visitNode(node.expression, visitor),
    [LuauAST_1.default.SyntaxKind.IfExpression]: (node, visitor) => {
        visitNode(node.condition, visitor);
        visitNode(node.expression, visitor);
        visitNode(node.alternative, visitor);
    },
    [LuauAST_1.default.SyntaxKind.InterpolatedString]: (node, visitor) => visitList(node.parts, visitor),
    [LuauAST_1.default.SyntaxKind.Array]: (node, visitor) => visitList(node.members, visitor),
    [LuauAST_1.default.SyntaxKind.Map]: (node, visitor) => visitList(node.fields, visitor),
    [LuauAST_1.default.SyntaxKind.Set]: (node, visitor) => visitList(node.members, visitor),
    [LuauAST_1.default.SyntaxKind.MixedTable]: (node, visitor) => visitList(node.fields, visitor),
    [LuauAST_1.default.SyntaxKind.Assignment]: (node, visitor) => {
        if (LuauAST_1.default.list.isList(node.left)) {
            visitList(node.left, visitor);
        }
        else {
            visitNode(node.left, visitor);
        }
        if (LuauAST_1.default.list.isList(node.right)) {
            visitList(node.right, visitor);
        }
        else {
            visitNode(node.right, visitor);
        }
    },
    [LuauAST_1.default.SyntaxKind.BreakStatement]: NOOP,
    [LuauAST_1.default.SyntaxKind.CallStatement]: (node, visitor) => visitNode(node.expression, visitor),
    [LuauAST_1.default.SyntaxKind.ContinueStatement]: NOOP,
    [LuauAST_1.default.SyntaxKind.DoStatement]: (node, visitor) => visitList(node.statements, visitor),
    [LuauAST_1.default.SyntaxKind.WhileStatement]: (node, visitor) => {
        visitNode(node.condition, visitor);
        visitList(node.statements, visitor);
    },
    [LuauAST_1.default.SyntaxKind.RepeatStatement]: (node, visitor) => {
        visitList(node.statements, visitor);
        visitNode(node.condition, visitor);
    },
    [LuauAST_1.default.SyntaxKind.IfStatement]: (node, visitor) => {
        visitNode(node.condition, visitor);
        visitList(node.statements, visitor);
        if (LuauAST_1.default.list.isList(node.elseBody)) {
            visitList(node.elseBody, visitor);
        }
        else {
            visitNode(node.elseBody, visitor);
        }
    },
    [LuauAST_1.default.SyntaxKind.NumericForStatement]: (node, visitor) => {
        visitNode(node.id, visitor);
        visitNode(node.start, visitor);
        visitNode(node.end, visitor);
        if (node.step) {
            visitNode(node.step, visitor);
        }
        visitList(node.statements, visitor);
    },
    [LuauAST_1.default.SyntaxKind.ForStatement]: (node, visitor) => {
        visitList(node.ids, visitor);
        visitList(node.statements, visitor);
    },
    [LuauAST_1.default.SyntaxKind.FunctionDeclaration]: (node, visitor) => {
        visitNode(node.name, visitor);
        visitList(node.parameters, visitor);
        visitList(node.statements, visitor);
    },
    [LuauAST_1.default.SyntaxKind.MethodDeclaration]: (node, visitor) => {
        visitNode(node.expression, visitor);
        visitList(node.parameters, visitor);
        visitList(node.statements, visitor);
    },
    [LuauAST_1.default.SyntaxKind.VariableDeclaration]: (node, visitor) => {
        if (LuauAST_1.default.list.isList(node.left)) {
            visitList(node.left, visitor);
        }
        else {
            visitNode(node.left, visitor);
        }
        if (node.right) {
            if (LuauAST_1.default.list.isList(node.right)) {
                visitList(node.right, visitor);
            }
            else {
                visitNode(node.right, visitor);
            }
        }
    },
    [LuauAST_1.default.SyntaxKind.ReturnStatement]: (node, visitor) => {
        if (LuauAST_1.default.list.isList(node.expression)) {
            visitList(node.expression, visitor);
        }
        else {
            visitNode(node.expression, visitor);
        }
    },
    [LuauAST_1.default.SyntaxKind.Comment]: NOOP,
    [LuauAST_1.default.SyntaxKind.MapField]: (node, visitor) => {
        visitNode(node.index, visitor);
        visitNode(node.value, visitor);
    },
    [LuauAST_1.default.SyntaxKind.InterpolatedStringPart]: NOOP,
});
function visitNode(node, visitor) {
    var _a, _b;
    (_a = visitor.before) === null || _a === void 0 ? void 0 : _a.call(visitor, node);
    KIND_TO_VISITOR[node.kind](node, visitor);
    (_b = visitor.after) === null || _b === void 0 ? void 0 : _b.call(visitor, node);
}
function visitList(list, visitor) {
    LuauAST_1.default.list.forEach(list, v => visitNode(v, visitor));
}
function visit(ast, visitor) {
    if (LuauAST_1.default.list.isList(ast)) {
        visitList(ast, visitor);
    }
    else {
        visitNode(ast, visitor);
    }
}
exports.visit = visit;
//# sourceMappingURL=visit.js.map