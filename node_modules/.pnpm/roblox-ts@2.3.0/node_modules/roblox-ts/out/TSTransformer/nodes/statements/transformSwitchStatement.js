"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformSwitchStatement = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("../expressions/transformExpression");
const transformStatementList_1 = require("../transformStatementList");
const createHoistDeclaration_1 = require("../../util/createHoistDeclaration");
const typescript_1 = __importDefault(require("typescript"));
function transformCaseClauseExpression(state, caseClauseExpression, switchExpression, fallThroughFlagId, canFallThroughTo) {
    let [expression, prereqStatements] = state.capture(() => (0, transformExpression_1.transformExpression)(state, caseClauseExpression));
    expression = luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ParenthesizedExpression, { expression });
    let condition = luau_ast_1.default.binary(switchExpression, "==", expression);
    if (canFallThroughTo) {
        if (!luau_ast_1.default.list.isEmpty(prereqStatements)) {
            const noFallThroughCondition = luau_ast_1.default.unary("not", fallThroughFlagId);
            luau_ast_1.default.list.push(prereqStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: fallThroughFlagId,
                operator: "=",
                right: condition,
            }));
            prereqStatements = luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
                condition: noFallThroughCondition,
                statements: prereqStatements,
                elseBody: luau_ast_1.default.list.make(),
            }));
            condition = fallThroughFlagId;
        }
        else {
            condition = luau_ast_1.default.binary(fallThroughFlagId, "or", condition);
        }
    }
    return {
        condition,
        prereqStatements,
    };
}
function transformCaseClause(state, node, switchExpression, fallThroughFlagId, canFallThroughTo, shouldUpdateFallThroughFlag) {
    const { condition, prereqStatements } = transformCaseClauseExpression(state, node.expression, switchExpression, fallThroughFlagId, canFallThroughTo);
    const nonEmptyStatements = node.statements.filter(v => !typescript_1.default.isEmptyStatement(v));
    const firstStatement = nonEmptyStatements[0];
    const statements = nonEmptyStatements.length === 1 && typescript_1.default.isBlock(firstStatement)
        ? (0, transformStatementList_1.transformStatementList)(state, firstStatement, firstStatement.statements)
        : (0, transformStatementList_1.transformStatementList)(state, node, node.statements);
    const canFallThroughFrom = statements.tail === undefined || !luau_ast_1.default.isFinalStatement(statements.tail.value);
    if (canFallThroughFrom && shouldUpdateFallThroughFlag) {
        luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: fallThroughFlagId,
            operator: "=",
            right: luau_ast_1.default.bool(true),
        }));
    }
    const clauseStatements = luau_ast_1.default.list.make();
    const hoistDeclaration = (0, createHoistDeclaration_1.createHoistDeclaration)(state, node);
    if (hoistDeclaration) {
        luau_ast_1.default.list.push(clauseStatements, hoistDeclaration);
    }
    luau_ast_1.default.list.push(clauseStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
        condition,
        statements,
        elseBody: luau_ast_1.default.list.make(),
    }));
    return {
        canFallThroughFrom,
        prereqs: prereqStatements,
        clauseStatements,
    };
}
function transformSwitchStatement(state, node) {
    const expression = state.pushToVarIfComplex((0, transformExpression_1.transformExpression)(state, node.expression), "exp");
    const fallThroughFlagId = luau_ast_1.default.tempId("fallthrough");
    let isFallThroughFlagNeeded = false;
    const statements = luau_ast_1.default.list.make();
    let canFallThroughTo = false;
    for (let i = 0; i < node.caseBlock.clauses.length; i++) {
        const caseClauseNode = node.caseBlock.clauses[i];
        if (typescript_1.default.isCaseClause(caseClauseNode)) {
            const shouldUpdateFallThroughFlag = i < node.caseBlock.clauses.length - 1 && typescript_1.default.isCaseClause(node.caseBlock.clauses[i + 1]);
            const { canFallThroughFrom, prereqs, clauseStatements } = transformCaseClause(state, caseClauseNode, expression, fallThroughFlagId, canFallThroughTo, shouldUpdateFallThroughFlag);
            luau_ast_1.default.list.pushList(statements, prereqs);
            luau_ast_1.default.list.pushList(statements, clauseStatements);
            canFallThroughTo = canFallThroughFrom;
            if (canFallThroughFrom) {
                isFallThroughFlagNeeded = true;
            }
        }
        else {
            luau_ast_1.default.list.pushList(statements, (0, transformStatementList_1.transformStatementList)(state, caseClauseNode, caseClauseNode.statements));
            break;
        }
    }
    if (isFallThroughFlagNeeded) {
        luau_ast_1.default.list.unshift(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: fallThroughFlagId,
            right: luau_ast_1.default.bool(false),
        }));
    }
    return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.RepeatStatement, {
        condition: luau_ast_1.default.bool(true),
        statements,
    }));
}
exports.transformSwitchStatement = transformSwitchStatement;
//# sourceMappingURL=transformSwitchStatement.js.map