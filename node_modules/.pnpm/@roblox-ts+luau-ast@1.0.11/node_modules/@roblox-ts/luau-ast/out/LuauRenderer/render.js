"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderAST = exports.render = void 0;
const LuauAST_1 = __importDefault(require("../LuauAST"));
const assert_1 = require("../LuauAST/util/assert");
const getKindName_1 = require("../LuauAST/util/getKindName");
const renderCallExpression_1 = require("./nodes/expressions/indexable/renderCallExpression");
const renderComputedIndexExpression_1 = require("./nodes/expressions/indexable/renderComputedIndexExpression");
const renderIdentifier_1 = require("./nodes/expressions/indexable/renderIdentifier");
const renderMethodCallExpression_1 = require("./nodes/expressions/indexable/renderMethodCallExpression");
const renderParenthesizedExpression_1 = require("./nodes/expressions/indexable/renderParenthesizedExpression");
const renderPropertyAccessExpression_1 = require("./nodes/expressions/indexable/renderPropertyAccessExpression");
const renderTemporaryIdentifier_1 = require("./nodes/expressions/indexable/renderTemporaryIdentifier");
const renderArray_1 = require("./nodes/expressions/renderArray");
const renderBinaryExpression_1 = require("./nodes/expressions/renderBinaryExpression");
const renderFunctionExpression_1 = require("./nodes/expressions/renderFunctionExpression");
const renderIfExpression_1 = require("./nodes/expressions/renderIfExpression");
const renderInterpolatedString_1 = require("./nodes/expressions/renderInterpolatedString");
const renderMap_1 = require("./nodes/expressions/renderMap");
const renderMixedTable_1 = require("./nodes/expressions/renderMixedTable");
const renderNumberLiteral_1 = require("./nodes/expressions/renderNumberLiteral");
const renderSet_1 = require("./nodes/expressions/renderSet");
const renderStringLiteral_1 = require("./nodes/expressions/renderStringLiteral");
const renderUnaryExpression_1 = require("./nodes/expressions/renderUnaryExpression");
const renderInterpolatedStringPart_1 = require("./nodes/fields/renderInterpolatedStringPart");
const renderMapField_1 = require("./nodes/fields/renderMapField");
const renderAssignment_1 = require("./nodes/statements/renderAssignment");
const renderBreakStatement_1 = require("./nodes/statements/renderBreakStatement");
const renderCallStatement_1 = require("./nodes/statements/renderCallStatement");
const renderComment_1 = require("./nodes/statements/renderComment");
const renderContinueStatement_1 = require("./nodes/statements/renderContinueStatement");
const renderDoStatement_1 = require("./nodes/statements/renderDoStatement");
const renderForStatement_1 = require("./nodes/statements/renderForStatement");
const renderFunctionDeclaration_1 = require("./nodes/statements/renderFunctionDeclaration");
const renderIfStatement_1 = require("./nodes/statements/renderIfStatement");
const renderMethodDeclaration_1 = require("./nodes/statements/renderMethodDeclaration");
const renderNumericForStatement_1 = require("./nodes/statements/renderNumericForStatement");
const renderRepeatStatement_1 = require("./nodes/statements/renderRepeatStatement");
const renderReturnStatement_1 = require("./nodes/statements/renderReturnStatement");
const renderVariableDeclaration_1 = require("./nodes/statements/renderVariableDeclaration");
const renderWhileStatement_1 = require("./nodes/statements/renderWhileStatement");
const RenderState_1 = require("./RenderState");
const solveTempIds_1 = require("./solveTempIds");
const identity_1 = require("./util/identity");
const renderStatements_1 = require("./util/renderStatements");
const visit_1 = require("./util/visit");
const KIND_TO_RENDERER = (0, identity_1.identity)({
    [LuauAST_1.default.SyntaxKind.Identifier]: renderIdentifier_1.renderIdentifier,
    [LuauAST_1.default.SyntaxKind.TemporaryIdentifier]: renderTemporaryIdentifier_1.renderTemporaryIdentifier,
    [LuauAST_1.default.SyntaxKind.ComputedIndexExpression]: renderComputedIndexExpression_1.renderComputedIndexExpression,
    [LuauAST_1.default.SyntaxKind.PropertyAccessExpression]: renderPropertyAccessExpression_1.renderPropertyAccessExpression,
    [LuauAST_1.default.SyntaxKind.CallExpression]: renderCallExpression_1.renderCallExpression,
    [LuauAST_1.default.SyntaxKind.MethodCallExpression]: renderMethodCallExpression_1.renderMethodCallExpression,
    [LuauAST_1.default.SyntaxKind.ParenthesizedExpression]: renderParenthesizedExpression_1.renderParenthesizedExpression,
    [LuauAST_1.default.SyntaxKind.None]: () => (0, assert_1.assert)(false, "Cannot render None"),
    [LuauAST_1.default.SyntaxKind.NilLiteral]: () => "nil",
    [LuauAST_1.default.SyntaxKind.FalseLiteral]: () => "false",
    [LuauAST_1.default.SyntaxKind.TrueLiteral]: () => "true",
    [LuauAST_1.default.SyntaxKind.NumberLiteral]: renderNumberLiteral_1.renderNumberLiteral,
    [LuauAST_1.default.SyntaxKind.StringLiteral]: renderStringLiteral_1.renderStringLiteral,
    [LuauAST_1.default.SyntaxKind.VarArgsLiteral]: () => "...",
    [LuauAST_1.default.SyntaxKind.FunctionExpression]: renderFunctionExpression_1.renderFunctionExpression,
    [LuauAST_1.default.SyntaxKind.BinaryExpression]: renderBinaryExpression_1.renderBinaryExpression,
    [LuauAST_1.default.SyntaxKind.UnaryExpression]: renderUnaryExpression_1.renderUnaryExpression,
    [LuauAST_1.default.SyntaxKind.IfExpression]: renderIfExpression_1.renderIfExpression,
    [LuauAST_1.default.SyntaxKind.InterpolatedString]: renderInterpolatedString_1.renderInterpolatedString,
    [LuauAST_1.default.SyntaxKind.Array]: renderArray_1.renderArray,
    [LuauAST_1.default.SyntaxKind.Map]: renderMap_1.renderMap,
    [LuauAST_1.default.SyntaxKind.Set]: renderSet_1.renderSet,
    [LuauAST_1.default.SyntaxKind.MixedTable]: renderMixedTable_1.renderMixedTable,
    [LuauAST_1.default.SyntaxKind.Assignment]: renderAssignment_1.renderAssignment,
    [LuauAST_1.default.SyntaxKind.BreakStatement]: renderBreakStatement_1.renderBreakStatement,
    [LuauAST_1.default.SyntaxKind.CallStatement]: renderCallStatement_1.renderCallStatement,
    [LuauAST_1.default.SyntaxKind.ContinueStatement]: renderContinueStatement_1.renderContinueStatement,
    [LuauAST_1.default.SyntaxKind.DoStatement]: renderDoStatement_1.renderDoStatement,
    [LuauAST_1.default.SyntaxKind.WhileStatement]: renderWhileStatement_1.renderWhileStatement,
    [LuauAST_1.default.SyntaxKind.RepeatStatement]: renderRepeatStatement_1.renderRepeatStatement,
    [LuauAST_1.default.SyntaxKind.IfStatement]: renderIfStatement_1.renderIfStatement,
    [LuauAST_1.default.SyntaxKind.NumericForStatement]: renderNumericForStatement_1.renderNumericForStatement,
    [LuauAST_1.default.SyntaxKind.ForStatement]: renderForStatement_1.renderForStatement,
    [LuauAST_1.default.SyntaxKind.FunctionDeclaration]: renderFunctionDeclaration_1.renderFunctionDeclaration,
    [LuauAST_1.default.SyntaxKind.MethodDeclaration]: renderMethodDeclaration_1.renderMethodDeclaration,
    [LuauAST_1.default.SyntaxKind.VariableDeclaration]: renderVariableDeclaration_1.renderVariableDeclaration,
    [LuauAST_1.default.SyntaxKind.ReturnStatement]: renderReturnStatement_1.renderReturnStatement,
    [LuauAST_1.default.SyntaxKind.Comment]: renderComment_1.renderComment,
    [LuauAST_1.default.SyntaxKind.MapField]: renderMapField_1.renderMapField,
    [LuauAST_1.default.SyntaxKind.InterpolatedStringPart]: renderInterpolatedStringPart_1.renderInterpolatedStringPart,
});
function render(state, node) {
    return KIND_TO_RENDERER[node.kind](state, node);
}
exports.render = render;
function debugAST(ast) {
    let indent = "";
    const pushIndent = () => (indent += "\t");
    const popIndent = () => (indent = indent.substring(1));
    (0, visit_1.visit)(ast, {
        before: node => {
            console.log(`${indent}${(0, getKindName_1.getKindName)(node.kind)}`);
            pushIndent();
        },
        after: () => {
            popIndent();
        },
    });
}
function renderAST(ast) {
    const state = new RenderState_1.RenderState();
    (0, solveTempIds_1.solveTempIds)(state, ast);
    return (0, renderStatements_1.renderStatements)(state, ast);
}
exports.renderAST = renderAST;
//# sourceMappingURL=render.js.map