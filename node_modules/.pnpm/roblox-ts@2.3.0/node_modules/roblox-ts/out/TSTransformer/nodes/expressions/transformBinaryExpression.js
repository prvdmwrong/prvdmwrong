"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformBinaryExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformArrayAssignmentPattern_1 = require("../binding/transformArrayAssignmentPattern");
const transformObjectAssignmentPattern_1 = require("../binding/transformObjectAssignmentPattern");
const transformExpression_1 = require("./transformExpression");
const transformInitializer_1 = require("../transformInitializer");
const transformLogical_1 = require("../transformLogical");
const transformLogicalOrCoalescingAssignmentExpression_1 = require("../transformLogicalOrCoalescingAssignmentExpression");
const transformWritable_1 = require("../transformWritable");
const assignment_1 = require("../../util/assignment");
const convertToIndexableExpression_1 = require("../../util/convertToIndexableExpression");
const createBinaryFromOperator_1 = require("../../util/createBinaryFromOperator");
const ensureTransformOrder_1 = require("../../util/ensureTransformOrder");
const getAssignableValue_1 = require("../../util/getAssignableValue");
const getKindName_1 = require("../../util/getKindName");
const isSymbolFromRobloxTypes_1 = require("../../util/isSymbolFromRobloxTypes");
const isUsedAsStatement_1 = require("../../util/isUsedAsStatement");
const traversal_1 = require("../../util/traversal");
const types_1 = require("../../util/types");
const validateNotAny_1 = require("../../util/validateNotAny");
const typescript_1 = __importDefault(require("typescript"));
function transformOptimizedArrayAssignmentPattern(state, assignmentPattern, rhs) {
    const variables = luau_ast_1.default.list.make();
    const writes = luau_ast_1.default.list.make();
    const writesPrereqs = luau_ast_1.default.list.make();
    const statements = state.capturePrereqs(() => {
        for (let element of assignmentPattern.elements) {
            if (typescript_1.default.isOmittedExpression(element)) {
                luau_ast_1.default.list.push(writes, luau_ast_1.default.tempId());
            }
            else if (typescript_1.default.isSpreadElement(element)) {
                DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noSpreadDestructuring(element));
            }
            else {
                let initializer;
                if (typescript_1.default.isBinaryExpression(element)) {
                    initializer = (0, traversal_1.skipDownwards)(element.right);
                    element = (0, traversal_1.skipDownwards)(element.left);
                }
                if (typescript_1.default.isIdentifier(element) ||
                    typescript_1.default.isElementAccessExpression(element) ||
                    typescript_1.default.isPropertyAccessExpression(element)) {
                    const [id, idPrereqs] = state.capture(() => (0, transformWritable_1.transformWritableExpression)(state, element, true));
                    luau_ast_1.default.list.pushList(writesPrereqs, idPrereqs);
                    luau_ast_1.default.list.push(writes, id);
                    if (initializer) {
                        state.prereq((0, transformInitializer_1.transformInitializer)(state, id, initializer));
                    }
                }
                else if (typescript_1.default.isArrayLiteralExpression(element)) {
                    const id = luau_ast_1.default.tempId("binding");
                    luau_ast_1.default.list.push(variables, id);
                    luau_ast_1.default.list.push(writes, id);
                    if (initializer) {
                        state.prereq((0, transformInitializer_1.transformInitializer)(state, id, initializer));
                    }
                    (0, transformArrayAssignmentPattern_1.transformArrayAssignmentPattern)(state, element, id);
                }
                else if (typescript_1.default.isObjectLiteralExpression(element)) {
                    const id = luau_ast_1.default.tempId("binding");
                    luau_ast_1.default.list.push(variables, id);
                    luau_ast_1.default.list.push(writes, id);
                    if (initializer) {
                        state.prereq((0, transformInitializer_1.transformInitializer)(state, id, initializer));
                    }
                    (0, transformObjectAssignmentPattern_1.transformObjectAssignmentPattern)(state, element, id);
                }
                else {
                    (0, assert_1.assert)(false, `transformOptimizedArrayAssignmentPattern invalid element: ${(0, getKindName_1.getKindName)(element.kind)}`);
                }
            }
        }
    });
    if (!luau_ast_1.default.list.isEmpty(variables)) {
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: variables,
            right: undefined,
        }));
    }
    state.prereqList(writesPrereqs);
    (0, assert_1.assert)(!luau_ast_1.default.list.isEmpty(writes));
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: writes,
        operator: "=",
        right: rhs,
    }));
    state.prereqList(statements);
}
function transformBinaryExpression(state, node) {
    const operatorKind = node.operatorToken.kind;
    (0, validateNotAny_1.validateNotAnyType)(state, node.left);
    (0, validateNotAny_1.validateNotAnyType)(state, node.right);
    if (operatorKind === typescript_1.default.SyntaxKind.EqualsEqualsToken) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noEqualsEquals(node));
        return luau_ast_1.default.none();
    }
    else if (operatorKind === typescript_1.default.SyntaxKind.ExclamationEqualsToken) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noExclamationEquals(node));
        return luau_ast_1.default.none();
    }
    if (operatorKind === typescript_1.default.SyntaxKind.AmpersandAmpersandToken ||
        operatorKind === typescript_1.default.SyntaxKind.BarBarToken ||
        operatorKind === typescript_1.default.SyntaxKind.QuestionQuestionToken) {
        return (0, transformLogical_1.transformLogical)(state, node);
    }
    if (typescript_1.default.isLogicalOrCoalescingAssignmentExpression(node)) {
        return (0, transformLogicalOrCoalescingAssignmentExpression_1.transformLogicalOrCoalescingAssignmentExpression)(state, node);
    }
    if (typescript_1.default.isAssignmentOperator(operatorKind)) {
        if (typescript_1.default.isArrayLiteralExpression(node.left)) {
            const rightExp = (0, transformExpression_1.transformExpression)(state, node.right);
            if (node.left.elements.length === 0) {
                if ((0, isUsedAsStatement_1.isUsedAsStatement)(node) && luau_ast_1.default.isArray(rightExp) && luau_ast_1.default.list.isEmpty(rightExp.members)) {
                    return luau_ast_1.default.none();
                }
                return rightExp;
            }
            if (luau_ast_1.default.isCall(rightExp) && (0, types_1.isLuaTupleType)(state)(state.getType(node.right))) {
                transformOptimizedArrayAssignmentPattern(state, node.left, rightExp);
                if (!(0, isUsedAsStatement_1.isUsedAsStatement)(node)) {
                    DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noLuaTupleDestructureAssignmentExpression(node));
                }
                return luau_ast_1.default.none();
            }
            if (luau_ast_1.default.isArray(rightExp) && !luau_ast_1.default.list.isEmpty(rightExp.members) && (0, isUsedAsStatement_1.isUsedAsStatement)(node)) {
                transformOptimizedArrayAssignmentPattern(state, node.left, rightExp.members);
                return luau_ast_1.default.none();
            }
            const parentId = state.pushToVar(rightExp, "binding");
            (0, transformArrayAssignmentPattern_1.transformArrayAssignmentPattern)(state, node.left, parentId);
            return parentId;
        }
        else if (typescript_1.default.isObjectLiteralExpression(node.left)) {
            const rightExp = (0, transformExpression_1.transformExpression)(state, node.right);
            if (node.left.properties.length === 0) {
                if ((0, isUsedAsStatement_1.isUsedAsStatement)(node) && luau_ast_1.default.isMap(rightExp) && luau_ast_1.default.list.isEmpty(rightExp.fields)) {
                    return luau_ast_1.default.none();
                }
                return rightExp;
            }
            const parentId = state.pushToVar(rightExp, "binding");
            (0, transformObjectAssignmentPattern_1.transformObjectAssignmentPattern)(state, node.left, parentId);
            return parentId;
        }
        const writableType = state.getType(node.left);
        const valueType = state.getType(node.right);
        const operator = (0, assignment_1.getSimpleAssignmentOperator)(writableType, operatorKind, valueType);
        const { writable, readable, value } = (0, transformWritable_1.transformWritableAssignment)(state, node.left, node.right, true, operator === undefined);
        if (operator !== undefined) {
            return (0, assignment_1.createAssignmentExpression)(state, writable, operator, (0, getAssignableValue_1.getAssignableValue)(operator, value, valueType));
        }
        else {
            return (0, assignment_1.createCompoundAssignmentExpression)(state, node, writable, writableType, readable, operatorKind, value, valueType);
        }
    }
    const [left, right] = (0, ensureTransformOrder_1.ensureTransformOrder)(state, [node.left, node.right]);
    if (operatorKind === typescript_1.default.SyntaxKind.InKeyword) {
        return luau_ast_1.default.binary(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
            expression: (0, convertToIndexableExpression_1.convertToIndexableExpression)(right),
            index: left,
        }), "~=", luau_ast_1.default.nil());
    }
    else if (operatorKind === typescript_1.default.SyntaxKind.InstanceOfKeyword) {
        const symbol = (0, types_1.getFirstDefinedSymbol)(state, state.getType(node.right));
        if ((0, isSymbolFromRobloxTypes_1.isSymbolFromRobloxTypes)(state, symbol)) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noRobloxSymbolInstanceof(node.right));
        }
        return luau_ast_1.default.call(state.TS(node, "instanceof"), [left, right]);
    }
    const leftType = state.getType(node.left);
    const rightType = state.getType(node.right);
    if (operatorKind === typescript_1.default.SyntaxKind.LessThanToken ||
        operatorKind === typescript_1.default.SyntaxKind.LessThanEqualsToken ||
        operatorKind === typescript_1.default.SyntaxKind.GreaterThanToken ||
        operatorKind === typescript_1.default.SyntaxKind.GreaterThanEqualsToken) {
        if ((!(0, types_1.isDefinitelyType)(leftType, types_1.isStringType) && !(0, types_1.isDefinitelyType)(leftType, types_1.isNumberType)) ||
            (!(0, types_1.isDefinitelyType)(rightType, types_1.isStringType) && !(0, types_1.isDefinitelyType)(leftType, types_1.isNumberType))) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noNonNumberStringRelationOperator(node));
        }
    }
    return (0, createBinaryFromOperator_1.createBinaryFromOperator)(state, node, left, leftType, operatorKind, right, rightType);
}
exports.transformBinaryExpression = transformBinaryExpression;
//# sourceMappingURL=transformBinaryExpression.js.map