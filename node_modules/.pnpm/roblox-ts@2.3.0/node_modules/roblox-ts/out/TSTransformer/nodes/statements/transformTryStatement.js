"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformTryStatement = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const assert_1 = require("../../../Shared/util/assert");
const transformBindingName_1 = require("../binding/transformBindingName");
const transformStatementList_1 = require("../transformStatementList");
const isBlockedByTryStatement_1 = require("../../util/isBlockedByTryStatement");
function transformCatchClause(state, node) {
    const parameters = luau_ast_1.default.list.make();
    const statements = luau_ast_1.default.list.make();
    if (node.variableDeclaration) {
        luau_ast_1.default.list.push(parameters, (0, transformBindingName_1.transformBindingName)(state, node.variableDeclaration.name, statements));
    }
    luau_ast_1.default.list.pushList(statements, (0, transformStatementList_1.transformStatementList)(state, node.block, node.block.statements));
    const catchFunction = luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.FunctionExpression, {
        parameters,
        hasDotDotDot: false,
        statements,
    });
    return catchFunction;
}
function transformIntoTryCall(state, node, exitTypeId, returnsId, tryUses) {
    const tryCallArgs = new Array();
    tryCallArgs.push(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.FunctionExpression, {
        parameters: luau_ast_1.default.list.make(),
        hasDotDotDot: false,
        statements: (0, transformStatementList_1.transformStatementList)(state, node.tryBlock, node.tryBlock.statements),
    }));
    if (node.catchClause) {
        tryCallArgs.push(transformCatchClause(state, node.catchClause));
    }
    else {
        (0, assert_1.assert)(node.finallyBlock);
        tryCallArgs.push(luau_ast_1.default.nil());
    }
    if (node.finallyBlock) {
        tryCallArgs.push(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.FunctionExpression, {
            parameters: luau_ast_1.default.list.make(),
            hasDotDotDot: false,
            statements: (0, transformStatementList_1.transformStatementList)(state, node.finallyBlock, node.finallyBlock.statements),
        }));
    }
    if (!tryUses.usesReturn && !tryUses.usesBreak && !tryUses.usesContinue) {
        return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
            expression: luau_ast_1.default.call(state.TS(node, "try"), tryCallArgs),
        });
    }
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
        left: luau_ast_1.default.list.make(exitTypeId, returnsId),
        right: luau_ast_1.default.call(state.TS(node, "try"), tryCallArgs),
    });
}
function createFlowControlCondition(state, node, exitTypeId, flowControlConstant) {
    return luau_ast_1.default.binary(exitTypeId, "==", state.TS(node, flowControlConstant));
}
function collapseFlowControlCases(exitTypeId, cases) {
    (0, assert_1.assert)(cases.length > 0);
    let nextStatements = luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
        condition: exitTypeId,
        statements: cases[cases.length - 1].statements,
        elseBody: luau_ast_1.default.list.make(),
    });
    for (let i = cases.length - 2; i >= 0; i--) {
        nextStatements = luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
            condition: cases[i].condition || exitTypeId,
            statements: cases[i].statements,
            elseBody: nextStatements,
        });
    }
    return luau_ast_1.default.list.make(nextStatements);
}
function transformFlowControl(state, node, exitTypeId, returnsId, tryUses) {
    const flowControlCases = new Array();
    if (!tryUses.usesReturn && !tryUses.usesBreak && !tryUses.usesContinue) {
        return luau_ast_1.default.list.make();
    }
    const returnBlocked = (0, isBlockedByTryStatement_1.isReturnBlockedByTryStatement)(node.parent);
    const breakBlocked = (0, isBlockedByTryStatement_1.isBreakBlockedByTryStatement)(node.parent);
    if (tryUses.usesReturn && returnBlocked) {
        state.markTryUses("usesReturn");
    }
    if (tryUses.usesBreak && breakBlocked) {
        state.markTryUses("usesBreak");
    }
    if (tryUses.usesContinue && breakBlocked) {
        state.markTryUses("usesContinue");
    }
    if (tryUses.usesReturn) {
        if (returnBlocked) {
            flowControlCases.push({
                condition: createFlowControlCondition(state, node, exitTypeId, "TRY_RETURN"),
                statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ReturnStatement, {
                    expression: luau_ast_1.default.list.make(exitTypeId, returnsId),
                })),
            });
            if (breakBlocked) {
                return collapseFlowControlCases(exitTypeId, flowControlCases);
            }
        }
        else {
            flowControlCases.push({
                condition: createFlowControlCondition(state, node, exitTypeId, "TRY_RETURN"),
                statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ReturnStatement, {
                    expression: luau_ast_1.default.call(luau_ast_1.default.globals.unpack, [returnsId]),
                })),
            });
        }
    }
    if (tryUses.usesBreak || tryUses.usesContinue) {
        if (breakBlocked) {
            flowControlCases.push({
                statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ReturnStatement, {
                    expression: exitTypeId,
                })),
            });
        }
        else {
            if (tryUses.usesBreak) {
                flowControlCases.push({
                    condition: createFlowControlCondition(state, node, exitTypeId, "TRY_BREAK"),
                    statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.BreakStatement, {})),
                });
            }
            if (tryUses.usesContinue) {
                flowControlCases.push({
                    condition: createFlowControlCondition(state, node, exitTypeId, "TRY_CONTINUE"),
                    statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ContinueStatement, {})),
                });
            }
        }
    }
    return collapseFlowControlCases(exitTypeId, flowControlCases);
}
function transformTryStatement(state, node) {
    const statements = luau_ast_1.default.list.make();
    const exitTypeId = luau_ast_1.default.tempId("exitType");
    const returnsId = luau_ast_1.default.tempId("returns");
    const tryUses = state.pushTryUsesStack();
    luau_ast_1.default.list.push(statements, transformIntoTryCall(state, node, exitTypeId, returnsId, tryUses));
    state.popTryUsesStack();
    luau_ast_1.default.list.pushList(statements, transformFlowControl(state, node, exitTypeId, returnsId, tryUses));
    return statements;
}
exports.transformTryStatement = transformTryStatement;
//# sourceMappingURL=transformTryStatement.js.map