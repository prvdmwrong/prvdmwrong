"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformForOfStatement = exports.transformForOfRangeMacro = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const TSTransformer_1 = require("../..");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformArrayAssignmentPattern_1 = require("../binding/transformArrayAssignmentPattern");
const transformBindingName_1 = require("../binding/transformBindingName");
const transformObjectAssignmentPattern_1 = require("../binding/transformObjectAssignmentPattern");
const transformExpression_1 = require("../expressions/transformExpression");
const transformInitializer_1 = require("../transformInitializer");
const transformStatementList_1 = require("../transformStatementList");
const transformWritable_1 = require("../transformWritable");
const convertToIndexableExpression_1 = require("../../util/convertToIndexableExpression");
const ensureTransformOrder_1 = require("../../util/ensureTransformOrder");
const getKindName_1 = require("../../util/getKindName");
const getStatements_1 = require("../../util/getStatements");
const traversal_1 = require("../../util/traversal");
const types_1 = require("../../util/types");
const validateIdentifier_1 = require("../../util/validateIdentifier");
const valueToIdStr_1 = require("../../util/valueToIdStr");
const typescript_1 = __importDefault(require("typescript"));
function makeForLoopBuilder(callback) {
    return (state, statements, name, exp) => {
        const ids = luau_ast_1.default.list.make();
        const initializers = luau_ast_1.default.list.make();
        const expression = callback(state, name, exp, ids, initializers);
        luau_ast_1.default.list.unshiftList(statements, initializers);
        return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ForStatement, { ids, expression, statements }));
    };
}
function transformForInitializerExpressionDirect(state, initializer, initializers, value) {
    if (typescript_1.default.isArrayLiteralExpression(initializer)) {
        const [parentId, prereqs] = state.capture(() => {
            const parentId = state.pushToVar(value, "binding");
            (0, transformArrayAssignmentPattern_1.transformArrayAssignmentPattern)(state, initializer, parentId);
            return parentId;
        });
        luau_ast_1.default.list.pushList(initializers, prereqs);
        return parentId;
    }
    else if (typescript_1.default.isObjectLiteralExpression(initializer)) {
        const [parentId, prereqs] = state.capture(() => {
            const parentId = state.pushToVar(value, "binding");
            (0, transformObjectAssignmentPattern_1.transformObjectAssignmentPattern)(state, initializer, parentId);
            return parentId;
        });
        luau_ast_1.default.list.pushList(initializers, prereqs);
        return parentId;
    }
    else {
        const expression = (0, transformWritable_1.transformWritableExpression)(state, initializer, false);
        luau_ast_1.default.list.push(initializers, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: expression,
            operator: "=",
            right: value,
        }));
    }
}
function transformForInitializer(state, initializer, initializers) {
    if (typescript_1.default.isVariableDeclarationList(initializer)) {
        return (0, transformBindingName_1.transformBindingName)(state, initializer.declarations[0].name, initializers);
    }
    else if (typescript_1.default.isArrayLiteralExpression(initializer)) {
        const parentId = luau_ast_1.default.tempId("binding");
        luau_ast_1.default.list.pushList(initializers, state.capturePrereqs(() => (0, transformArrayAssignmentPattern_1.transformArrayAssignmentPattern)(state, initializer, parentId)));
        return parentId;
    }
    else if (typescript_1.default.isObjectLiteralExpression(initializer)) {
        const parentId = luau_ast_1.default.tempId("binding");
        luau_ast_1.default.list.pushList(initializers, state.capturePrereqs(() => (0, transformObjectAssignmentPattern_1.transformObjectAssignmentPattern)(state, initializer, parentId)));
        return parentId;
    }
    else {
        const valueId = luau_ast_1.default.tempId("v");
        const expression = (0, transformWritable_1.transformWritableExpression)(state, initializer, false);
        luau_ast_1.default.list.push(initializers, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: expression,
            operator: "=",
            right: valueId,
        }));
        return valueId;
    }
}
const buildArrayLoop = makeForLoopBuilder((state, initializer, exp, ids, initializers) => {
    luau_ast_1.default.list.push(ids, luau_ast_1.default.tempId());
    luau_ast_1.default.list.push(ids, transformForInitializer(state, initializer, initializers));
    return exp;
});
const buildSetLoop = makeForLoopBuilder((state, initializer, exp, ids, initializers) => {
    luau_ast_1.default.list.push(ids, transformForInitializer(state, initializer, initializers));
    return exp;
});
function transformInLineArrayBindingPattern(state, pattern, ids, initializers) {
    for (const element of pattern.elements) {
        if (typescript_1.default.isOmittedExpression(element)) {
            luau_ast_1.default.list.push(ids, luau_ast_1.default.tempId());
        }
        else if (typescript_1.default.isSpreadElement(element)) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noSpreadDestructuring(element));
        }
        else {
            const id = (0, transformBindingName_1.transformBindingName)(state, element.name, initializers);
            if (element.initializer) {
                luau_ast_1.default.list.push(initializers, (0, transformInitializer_1.transformInitializer)(state, id, element.initializer));
            }
            luau_ast_1.default.list.push(ids, id);
        }
    }
}
function transformInLineArrayAssignmentPattern(state, assignmentPattern, ids, initializers) {
    luau_ast_1.default.list.pushList(initializers, state.capturePrereqs(() => {
        for (let element of assignmentPattern.elements) {
            if (typescript_1.default.isOmittedExpression(element)) {
                luau_ast_1.default.list.push(ids, luau_ast_1.default.tempId());
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
                const valueId = luau_ast_1.default.tempId("binding");
                if (typescript_1.default.isIdentifier(element) ||
                    typescript_1.default.isElementAccessExpression(element) ||
                    typescript_1.default.isPropertyAccessExpression(element)) {
                    const id = (0, transformWritable_1.transformWritableExpression)(state, element, initializer !== undefined);
                    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                        left: id,
                        operator: "=",
                        right: valueId,
                    }));
                    if (initializer) {
                        state.prereq((0, transformInitializer_1.transformInitializer)(state, id, initializer));
                    }
                }
                else if (typescript_1.default.isArrayLiteralExpression(element)) {
                    if (initializer) {
                        state.prereq((0, transformInitializer_1.transformInitializer)(state, valueId, initializer));
                    }
                    (0, transformArrayAssignmentPattern_1.transformArrayAssignmentPattern)(state, element, valueId);
                }
                else if (typescript_1.default.isObjectLiteralExpression(element)) {
                    if (initializer) {
                        state.prereq((0, transformInitializer_1.transformInitializer)(state, valueId, initializer));
                    }
                    (0, transformObjectAssignmentPattern_1.transformObjectAssignmentPattern)(state, element, valueId);
                }
                else {
                    (0, assert_1.assert)(false, `transformInLineArrayAssignmentPattern invalid element: ${(0, getKindName_1.getKindName)(element.kind)}`);
                }
                luau_ast_1.default.list.push(ids, valueId);
            }
        }
    }));
}
const buildMapLoop = makeForLoopBuilder((state, initializer, exp, ids, initializers) => {
    if (typescript_1.default.isVariableDeclarationList(initializer)) {
        const name = initializer.declarations[0].name;
        if (typescript_1.default.isArrayBindingPattern(name)) {
            transformInLineArrayBindingPattern(state, name, ids, initializers);
            return exp;
        }
    }
    else if (typescript_1.default.isArrayLiteralExpression(initializer)) {
        transformInLineArrayAssignmentPattern(state, initializer, ids, initializers);
        return exp;
    }
    const keyId = luau_ast_1.default.tempId("k");
    const valueId = luau_ast_1.default.tempId("v");
    luau_ast_1.default.list.push(ids, keyId);
    luau_ast_1.default.list.push(ids, valueId);
    if (typescript_1.default.isVariableDeclarationList(initializer)) {
        const bindingList = luau_ast_1.default.list.make();
        luau_ast_1.default.list.push(initializers, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: transformForInitializer(state, initializer, bindingList),
            right: luau_ast_1.default.array([keyId, valueId]),
        }));
        luau_ast_1.default.list.pushList(initializers, bindingList);
    }
    else {
        transformForInitializerExpressionDirect(state, initializer, initializers, luau_ast_1.default.array([keyId, valueId]));
    }
    return exp;
});
const buildStringLoop = makeForLoopBuilder((state, initializer, exp, ids, initializers) => {
    luau_ast_1.default.list.push(ids, transformForInitializer(state, initializer, initializers));
    return luau_ast_1.default.call(luau_ast_1.default.globals.string.gmatch, [exp, luau_ast_1.default.globals.utf8.charpattern]);
});
const buildIterableFunctionLoop = makeForLoopBuilder((state, initializer, exp, ids, initializers) => {
    luau_ast_1.default.list.push(ids, transformForInitializer(state, initializer, initializers));
    return exp;
});
function makeIterableFunctionLuaTupleShorthand(state, array, statements, expression) {
    const ids = luau_ast_1.default.list.make();
    const initializers = luau_ast_1.default.list.make();
    if (typescript_1.default.isArrayBindingPattern(array)) {
        transformInLineArrayBindingPattern(state, array, ids, initializers);
    }
    else {
        transformInLineArrayAssignmentPattern(state, array, ids, initializers);
    }
    luau_ast_1.default.list.unshiftList(statements, initializers);
    return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ForStatement, { ids, expression, statements }));
}
const buildIterableFunctionLuaTupleLoop = type => (state, statements, initializer, exp) => {
    if (typescript_1.default.isVariableDeclarationList(initializer)) {
        const name = initializer.declarations[0].name;
        if (typescript_1.default.isArrayBindingPattern(name)) {
            return makeIterableFunctionLuaTupleShorthand(state, name, statements, exp);
        }
    }
    else if (typescript_1.default.isArrayLiteralExpression(initializer)) {
        return makeIterableFunctionLuaTupleShorthand(state, initializer, statements, exp);
    }
    const iteratorReturnIds = new Array();
    const luaTupleType = type.getCallSignatures()[0].getReturnType();
    (0, assert_1.assert)(luaTupleType && luaTupleType.aliasTypeArguments && luaTupleType.aliasTypeArguments.length === 1, "Incorrect LuaTuple<T> type arguments");
    const tupleArgType = luaTupleType.aliasTypeArguments[0];
    if (typescript_1.default.isVariableDeclarationList(initializer) &&
        state.typeChecker.isTupleType(tupleArgType) &&
        !(tupleArgType.target.combinedFlags & typescript_1.default.ElementFlags.Rest)) {
        const tupleType = tupleArgType.target;
        for (let i = 0; i < tupleType.elementFlags.length; i++) {
            let name = "element";
            if (tupleType.labeledElementDeclarations) {
                const label = tupleType.labeledElementDeclarations[i];
                if (label && typescript_1.default.isIdentifier(label.name) && luau_ast_1.default.isValidIdentifier(label.name.text)) {
                    name = label.name.text;
                }
            }
            iteratorReturnIds.push(luau_ast_1.default.tempId(name));
        }
    }
    else {
        const iterFuncId = state.pushToVar(exp, (0, valueToIdStr_1.valueToIdStr)(exp) || "iterFunc");
        const loopStatements = luau_ast_1.default.list.make();
        const initializerStatements = luau_ast_1.default.list.make();
        const valueId = transformForInitializer(state, initializer, initializerStatements);
        luau_ast_1.default.list.push(loopStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: valueId,
            right: luau_ast_1.default.array([luau_ast_1.default.call(iterFuncId)]),
        }));
        luau_ast_1.default.list.push(loopStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
            condition: luau_ast_1.default.binary(luau_ast_1.default.unary("#", valueId), "==", luau_ast_1.default.number(0)),
            statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.BreakStatement, {})),
            elseBody: luau_ast_1.default.list.make(),
        }));
        luau_ast_1.default.list.pushList(loopStatements, initializerStatements);
        luau_ast_1.default.list.pushList(loopStatements, statements);
        return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.WhileStatement, {
            condition: luau_ast_1.default.bool(true),
            statements: loopStatements,
        }));
    }
    const tupleId = transformForInitializer(state, initializer, statements);
    const builder = makeForLoopBuilder((state, initializer, exp, ids, initializers) => {
        for (const id of iteratorReturnIds) {
            luau_ast_1.default.list.push(ids, id);
        }
        luau_ast_1.default.list.push(initializers, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: tupleId,
            right: luau_ast_1.default.array(iteratorReturnIds),
        }));
        return exp;
    });
    return builder(state, statements, initializer, exp);
};
const buildGeneratorLoop = makeForLoopBuilder((state, initializer, exp, ids, initializers) => {
    const loopId = luau_ast_1.default.tempId("result");
    luau_ast_1.default.list.push(ids, loopId);
    luau_ast_1.default.list.push(initializers, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
        condition: luau_ast_1.default.property(loopId, "done"),
        statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.BreakStatement, {})),
        elseBody: luau_ast_1.default.list.make(),
    }));
    if (typescript_1.default.isVariableDeclarationList(initializer)) {
        const bindingList = luau_ast_1.default.list.make();
        luau_ast_1.default.list.push(initializers, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: transformForInitializer(state, initializer, bindingList),
            right: luau_ast_1.default.property(loopId, "value"),
        }));
        luau_ast_1.default.list.pushList(initializers, bindingList);
    }
    else {
        transformForInitializerExpressionDirect(state, initializer, initializers, luau_ast_1.default.property(loopId, "value"));
    }
    return luau_ast_1.default.property((0, convertToIndexableExpression_1.convertToIndexableExpression)(exp), "next");
});
function getLoopBuilder(state, node, type) {
    if ((0, types_1.isDefinitelyType)(type, (0, types_1.isArrayType)(state))) {
        return buildArrayLoop;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isSetType)(state))) {
        return buildSetLoop;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isMapType)(state))) {
        return buildMapLoop;
    }
    else if ((0, types_1.isDefinitelyType)(type, types_1.isStringType)) {
        return buildStringLoop;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isIterableFunctionLuaTupleType)(state))) {
        return buildIterableFunctionLuaTupleLoop(type);
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isIterableFunctionType)(state))) {
        return buildIterableFunctionLoop;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isGeneratorType)(state))) {
        return buildGeneratorLoop;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isIterableType)(state))) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noIterableIteration(node));
        return () => luau_ast_1.default.list.make();
    }
    else if (type.isUnion()) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noMacroUnion(node));
        return () => luau_ast_1.default.list.make();
    }
    else {
        (0, assert_1.assert)(false, `ForOf iteration type not implemented: ${state.typeChecker.typeToString(type)}`);
    }
}
function findRangeMacro(state, node) {
    const expression = (0, traversal_1.skipDownwards)(node.expression);
    if (typescript_1.default.isCallExpression(expression)) {
        const symbol = (0, types_1.getFirstDefinedSymbol)(state, state.getType(expression.expression));
        if (symbol && symbol === state.services.macroManager.getSymbolOrThrow(TSTransformer_1.SYMBOL_NAMES.$range)) {
            return expression;
        }
    }
}
function transformForOfRangeMacro(state, node, macroCall) {
    const result = luau_ast_1.default.list.make();
    const statements = luau_ast_1.default.list.make();
    const id = transformForInitializer(state, node.initializer, statements);
    const [[start, end, step], prereqs] = state.capture(() => (0, ensureTransformOrder_1.ensureTransformOrder)(state, macroCall.arguments));
    luau_ast_1.default.list.pushList(result, prereqs);
    luau_ast_1.default.list.pushList(statements, (0, transformStatementList_1.transformStatementList)(state, node.statement, (0, getStatements_1.getStatements)(node.statement)));
    luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.NumericForStatement, {
        id,
        start,
        end,
        step: step === undefined || luau_ast_1.default.isNumberLiteral(step) ? step : luau_ast_1.default.binary(step, "or", luau_ast_1.default.number(1)),
        statements,
    }));
    return result;
}
exports.transformForOfRangeMacro = transformForOfRangeMacro;
function transformForOfStatement(state, node) {
    if (node.awaitModifier) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noAwaitForOf(node));
    }
    if (typescript_1.default.isVariableDeclarationList(node.initializer)) {
        const name = node.initializer.declarations[0].name;
        if (typescript_1.default.isIdentifier(name)) {
            (0, validateIdentifier_1.validateIdentifier)(state, name);
        }
    }
    const rangeMacroCall = findRangeMacro(state, node);
    if (rangeMacroCall) {
        return transformForOfRangeMacro(state, node, rangeMacroCall);
    }
    const result = luau_ast_1.default.list.make();
    const [exp, expPrereqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, node.expression));
    luau_ast_1.default.list.pushList(result, expPrereqs);
    const expType = state.getType(node.expression);
    const statements = (0, transformStatementList_1.transformStatementList)(state, node.statement, (0, getStatements_1.getStatements)(node.statement));
    const loopBuilder = getLoopBuilder(state, node.expression, expType);
    luau_ast_1.default.list.pushList(result, loopBuilder(state, statements, node.initializer, exp));
    return result;
}
exports.transformForOfStatement = transformForOfStatement;
//# sourceMappingURL=transformForOfStatement.js.map