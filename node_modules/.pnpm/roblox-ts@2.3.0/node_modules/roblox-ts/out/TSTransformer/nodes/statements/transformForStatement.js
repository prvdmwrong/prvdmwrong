"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformForStatement = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformExpression_1 = require("../expressions/transformExpression");
const transformIdentifier_1 = require("../expressions/transformIdentifier");
const transformExpressionStatement_1 = require("./transformExpressionStatement");
const transformVariableStatement_1 = require("./transformVariableStatement");
const transformStatementList_1 = require("../transformStatementList");
const createTruthinessChecks_1 = require("../../util/createTruthinessChecks");
const getDeclaredVariables_1 = require("../../util/getDeclaredVariables");
const getStatements_1 = require("../../util/getStatements");
const offset_1 = require("../../util/offset");
const traversal_1 = require("../../util/traversal");
const types_1 = require("../../util/types");
const typescript_1 = __importDefault(require("typescript"));
function addFinalizersToIfStatement(node, finalizers) {
    if (luau_ast_1.default.list.isNonEmpty(node.statements)) {
        addFinalizers(node.statements, node.statements.head, finalizers);
    }
    if (luau_ast_1.default.list.isList(node.elseBody)) {
        if (luau_ast_1.default.list.isNonEmpty(node.elseBody)) {
            addFinalizers(node.elseBody, node.elseBody.head, finalizers);
        }
    }
    else {
        addFinalizersToIfStatement(node.elseBody, finalizers);
    }
}
function addFinalizers(list, node, finalizers) {
    (0, assert_1.assert)(!luau_ast_1.default.list.isEmpty(list));
    const statement = node.value;
    if (luau_ast_1.default.isContinueStatement(statement)) {
        const finalizersClone = luau_ast_1.default.list.clone(finalizers);
        luau_ast_1.default.list.forEach(finalizersClone, node => (node.parent = statement.parent));
        if (node.prev) {
            node.prev.next = finalizersClone.head;
        }
        else if (node === list.head) {
            list.head = finalizersClone.head;
        }
        node.prev = finalizersClone.tail;
        finalizersClone.tail.next = node;
    }
    if (luau_ast_1.default.isDoStatement(statement)) {
        if (luau_ast_1.default.list.isNonEmpty(statement.statements)) {
            addFinalizers(statement.statements, statement.statements.head, finalizers);
        }
    }
    else if (luau_ast_1.default.isIfStatement(statement)) {
        addFinalizersToIfStatement(statement, finalizers);
    }
    if (node.next) {
        addFinalizers(list, node.next, finalizers);
    }
}
function canSkipClone(state, initializer, id) {
    return !typescript_1.default.FindAllReferences.Core.isSymbolReferencedInFile(id, state.typeChecker, id.getSourceFile(), initializer);
}
function isIdWriteOrAsyncRead(state, forStatement, id) {
    return typescript_1.default.FindAllReferences.Core.eachSymbolReferenceInFile(id, state.typeChecker, id.getSourceFile(), token => {
        if (typescript_1.default.isWriteAccess(token) &&
            (!forStatement.incrementor || !(0, traversal_1.isAncestorOf)(forStatement.incrementor, token))) {
            return true;
        }
        const ancestor = (0, traversal_1.getAncestor)(token, v => v === forStatement || typescript_1.default.isFunctionLike(v));
        if (ancestor && ancestor !== forStatement) {
            return true;
        }
    }, forStatement);
}
function transformForStatementFallback(state, node) {
    const { initializer, condition, incrementor, statement } = node;
    const result = luau_ast_1.default.list.make();
    const whileStatements = luau_ast_1.default.list.make();
    const finalizerStatements = luau_ast_1.default.list.make();
    const variables = initializer && typescript_1.default.isVariableDeclarationList(initializer) ? (0, getDeclaredVariables_1.getDeclaredVariables)(initializer) : [];
    const hasWriteOrAsyncRead = new Set();
    const skipClone = new Set();
    if (initializer && typescript_1.default.isVariableDeclarationList(initializer)) {
        for (const id of variables) {
            const symbol = state.typeChecker.getSymbolAtLocation(id);
            (0, assert_1.assert)(symbol);
            if (isIdWriteOrAsyncRead(state, node, id)) {
                hasWriteOrAsyncRead.add(symbol);
            }
            if (canSkipClone(state, initializer, id)) {
                skipClone.add(symbol);
            }
        }
    }
    if (initializer) {
        if (typescript_1.default.isVariableDeclarationList(initializer)) {
            if ((0, transformVariableStatement_1.isVarDeclaration)(initializer)) {
                DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noVar(node));
            }
            for (const id of variables) {
                const symbol = state.typeChecker.getSymbolAtLocation(id);
                (0, assert_1.assert)(symbol);
                if (hasWriteOrAsyncRead.has(symbol)) {
                    if (skipClone.has(symbol)) {
                        state.symbolToIdMap.set(symbol, luau_ast_1.default.tempId(id.getText()));
                    }
                    else {
                        const copyId = luau_ast_1.default.tempId(`${id.getText()}Copy`);
                        state.symbolToIdMap.set(symbol, copyId);
                    }
                }
            }
            for (const declaration of initializer.declarations) {
                const [decStatements, decPrereqs] = state.capture(() => {
                    const result = luau_ast_1.default.list.make();
                    const [decStatements, decPrereqs] = state.capture(() => (0, transformVariableStatement_1.transformVariableDeclaration)(state, declaration));
                    luau_ast_1.default.list.pushList(result, decPrereqs);
                    luau_ast_1.default.list.pushList(result, decStatements);
                    return result;
                });
                luau_ast_1.default.list.pushList(result, decPrereqs);
                luau_ast_1.default.list.pushList(result, decStatements);
            }
            for (const id of variables) {
                const symbol = state.typeChecker.getSymbolAtLocation(id);
                (0, assert_1.assert)(symbol);
                if (hasWriteOrAsyncRead.has(symbol)) {
                    let tempId;
                    if (skipClone.has(symbol)) {
                        tempId = state.symbolToIdMap.get(symbol);
                        (0, assert_1.assert)(tempId);
                    }
                    else {
                        tempId = luau_ast_1.default.tempId(id.getText());
                        const copyId = state.symbolToIdMap.get(symbol);
                        (0, assert_1.assert)(copyId);
                        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
                            left: tempId,
                            right: copyId,
                        }));
                    }
                    state.symbolToIdMap.delete(symbol);
                    const realId = (0, transformIdentifier_1.transformIdentifierDefined)(state, id);
                    luau_ast_1.default.list.push(whileStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
                        left: realId,
                        right: tempId,
                    }));
                    luau_ast_1.default.list.push(finalizerStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                        left: tempId,
                        operator: "=",
                        right: realId,
                    }));
                }
            }
        }
        else {
            const [statements, prereqs] = state.capture(() => (0, transformExpressionStatement_1.transformExpressionStatementInner)(state, initializer));
            luau_ast_1.default.list.pushList(result, prereqs);
            luau_ast_1.default.list.pushList(result, statements);
        }
    }
    if (incrementor) {
        const shouldIncrement = luau_ast_1.default.tempId("shouldIncrement");
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: shouldIncrement,
            right: luau_ast_1.default.bool(false),
        }));
        const incrementorStatements = luau_ast_1.default.list.make();
        const [statements, prereqs] = state.capture(() => (0, transformExpressionStatement_1.transformExpressionStatementInner)(state, incrementor));
        luau_ast_1.default.list.pushList(incrementorStatements, prereqs);
        luau_ast_1.default.list.pushList(incrementorStatements, statements);
        luau_ast_1.default.list.push(whileStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
            condition: shouldIncrement,
            statements: incrementorStatements,
            elseBody: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: shouldIncrement,
                operator: "=",
                right: luau_ast_1.default.bool(true),
            })),
        }));
    }
    let [conditionExp, conditionPrereqs] = state.capture(() => {
        if (condition) {
            return (0, createTruthinessChecks_1.createTruthinessChecks)(state, (0, transformExpression_1.transformExpression)(state, condition), condition);
        }
        else {
            return luau_ast_1.default.bool(true);
        }
    });
    luau_ast_1.default.list.pushList(whileStatements, conditionPrereqs);
    if (!luau_ast_1.default.list.isEmpty(whileStatements)) {
        if (condition) {
            luau_ast_1.default.list.push(whileStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
                condition: luau_ast_1.default.unary("not", conditionExp),
                statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.BreakStatement, {})),
                elseBody: luau_ast_1.default.list.make(),
            }));
        }
        conditionExp = luau_ast_1.default.bool(true);
    }
    luau_ast_1.default.list.pushList(whileStatements, (0, transformStatementList_1.transformStatementList)(state, statement, (0, getStatements_1.getStatements)(statement)));
    if (luau_ast_1.default.list.isNonEmpty(whileStatements) && luau_ast_1.default.list.isNonEmpty(finalizerStatements)) {
        addFinalizers(whileStatements, whileStatements.head, finalizerStatements);
    }
    if (!whileStatements.tail || !luau_ast_1.default.isFinalStatement(whileStatements.tail.value)) {
        luau_ast_1.default.list.pushList(whileStatements, finalizerStatements);
    }
    luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.WhileStatement, {
        condition: conditionExp,
        statements: whileStatements,
    }));
    return result.head === result.tail
        ? result
        : luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.DoStatement, { statements: result }));
}
function getOptimizedIncrementorStepValue(state, incrementor, idSymbol) {
    if (typescript_1.default.isBinaryExpression(incrementor) &&
        typescript_1.default.isIdentifier(incrementor.left) &&
        state.typeChecker.getSymbolAtLocation(incrementor.left) === idSymbol &&
        incrementor.operatorToken.kind === typescript_1.default.SyntaxKind.PlusEqualsToken &&
        typescript_1.default.isNumericLiteral(incrementor.right) &&
        isProbablyInteger(state, incrementor.right)) {
        return Number(incrementor.right.getText());
    }
    else if (typescript_1.default.isBinaryExpression(incrementor) &&
        incrementor.operatorToken.kind === typescript_1.default.SyntaxKind.MinusEqualsToken &&
        typescript_1.default.isNumericLiteral(incrementor.right) &&
        isProbablyInteger(state, incrementor.right)) {
        return -Number(incrementor.right.getText());
    }
    else if ((typescript_1.default.isPostfixUnaryExpression(incrementor) || typescript_1.default.isPrefixUnaryExpression(incrementor)) &&
        typescript_1.default.isIdentifier(incrementor.operand) &&
        state.typeChecker.getSymbolAtLocation(incrementor.operand) === idSymbol &&
        incrementor.operator === typescript_1.default.SyntaxKind.PlusPlusToken) {
        return 1;
    }
    else if ((typescript_1.default.isPostfixUnaryExpression(incrementor) || typescript_1.default.isPrefixUnaryExpression(incrementor)) &&
        typescript_1.default.isIdentifier(incrementor.operand) &&
        state.typeChecker.getSymbolAtLocation(incrementor.operand) === idSymbol &&
        incrementor.operator === typescript_1.default.SyntaxKind.MinusMinusToken) {
        return -1;
    }
    return undefined;
}
function isSizeMacro(state, expression) {
    if (typescript_1.default.isCallExpression(expression)) {
        const expType = state.typeChecker.getNonOptionalType(state.getType(expression.expression));
        const symbol = (0, types_1.getFirstDefinedSymbol)(state, expType);
        if (symbol) {
            const macro = state.services.macroManager.getPropertyCallMacro(symbol);
            if (macro && symbol.name === "size") {
                return true;
            }
        }
    }
    return false;
}
function isMutatedInBody(state, identifier, body) {
    return (typescript_1.default.FindAllReferences.Core.eachSymbolReferenceInFile(identifier, state.typeChecker, identifier.getSourceFile(), token => {
        const parent = (0, traversal_1.skipUpwards)(token).parent;
        if (typescript_1.default.isAssignmentExpression(parent) && (0, traversal_1.skipDownwards)(parent.left) === token) {
            return true;
        }
        else if (typescript_1.default.isUnaryExpressionWithWrite(parent) && (0, traversal_1.skipDownwards)(parent.operand) === token) {
            return true;
        }
        return false;
    }, body) === true);
}
function isProbablyInteger(state, expression) {
    if (typescript_1.default.isNumericLiteral(expression)) {
        return Number.isInteger(Number(expression.getText()));
    }
    else if (typescript_1.default.isBinaryExpression(expression)) {
        if (expression.operatorToken.kind === typescript_1.default.SyntaxKind.PlusToken ||
            expression.operatorToken.kind === typescript_1.default.SyntaxKind.MinusToken ||
            expression.operatorToken.kind === typescript_1.default.SyntaxKind.AsteriskToken ||
            expression.operatorToken.kind === typescript_1.default.SyntaxKind.AsteriskAsteriskToken) {
            return isProbablyInteger(state, expression.left) && isProbablyInteger(state, expression.right);
        }
    }
    else if (typescript_1.default.isPrefixUnaryExpression(expression)) {
        if (expression.operator === typescript_1.default.SyntaxKind.PlusToken || expression.operator === typescript_1.default.SyntaxKind.MinusToken) {
            return isProbablyInteger(state, expression.operand);
        }
    }
    else if (isSizeMacro(state, expression)) {
        return true;
    }
    else if ((0, types_1.isDefinitelyType)(state.getType(expression), t => t.isNumberLiteral() && Number.isInteger(t.value))) {
        return true;
    }
    return false;
}
function transformForStatementOptimized(state, node) {
    const { initializer, condition, incrementor, statement } = node;
    if (!initializer || !typescript_1.default.isVariableDeclarationList(initializer) || initializer.declarations.length !== 1) {
        return undefined;
    }
    const { name: decName, initializer: decInit } = initializer.declarations[0];
    if (!typescript_1.default.isIdentifier(decName) || decInit === undefined) {
        return undefined;
    }
    const idSymbol = state.typeChecker.getSymbolAtLocation(decName);
    if (!idSymbol) {
        return undefined;
    }
    if (!isProbablyInteger(state, decInit)) {
        return undefined;
    }
    if (!incrementor) {
        return undefined;
    }
    const stepValue = getOptimizedIncrementorStepValue(state, incrementor, idSymbol);
    if (stepValue === undefined) {
        return undefined;
    }
    if (!condition || !typescript_1.default.isBinaryExpression(condition)) {
        return undefined;
    }
    if (condition.operatorToken.kind === typescript_1.default.SyntaxKind.LessThanToken ||
        condition.operatorToken.kind === typescript_1.default.SyntaxKind.LessThanEqualsToken) {
        if (stepValue < 0) {
            return undefined;
        }
    }
    else if (condition.operatorToken.kind === typescript_1.default.SyntaxKind.GreaterThanToken ||
        condition.operatorToken.kind === typescript_1.default.SyntaxKind.GreaterThanEqualsToken) {
        if (stepValue > 0) {
            return undefined;
        }
    }
    else {
        return undefined;
    }
    if (!isProbablyInteger(state, condition.right)) {
        return undefined;
    }
    if (isMutatedInBody(state, decName, statement)) {
        return undefined;
    }
    const result = luau_ast_1.default.list.make();
    const id = (0, transformIdentifier_1.transformIdentifierDefined)(state, decName);
    const [start, startPrereqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, decInit));
    luau_ast_1.default.list.pushList(result, startPrereqs);
    let [end, endPrereqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, condition.right));
    luau_ast_1.default.list.pushList(result, endPrereqs);
    const step = luau_ast_1.default.number(stepValue);
    const statements = (0, transformStatementList_1.transformStatementList)(state, statement, (0, getStatements_1.getStatements)(statement));
    if (condition.operatorToken.kind === typescript_1.default.SyntaxKind.LessThanToken) {
        end = (0, offset_1.offset)(end, -1);
    }
    else if (condition.operatorToken.kind === typescript_1.default.SyntaxKind.GreaterThanToken) {
        end = (0, offset_1.offset)(end, 1);
    }
    luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.NumericForStatement, { id, start, end, step, statements }));
    return result;
}
function transformForStatement(state, node) {
    if (state.data.projectOptions.optimizedLoops) {
        const optimized = transformForStatementOptimized(state, node);
        if (optimized) {
            return optimized;
        }
    }
    return transformForStatementFallback(state, node);
}
exports.transformForStatement = transformForStatement;
//# sourceMappingURL=transformForStatement.js.map