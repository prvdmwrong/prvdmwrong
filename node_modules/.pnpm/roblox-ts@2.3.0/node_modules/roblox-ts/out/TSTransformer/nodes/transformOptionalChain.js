"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformOptionalChain = exports.flattenOptionalChain = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../Shared/diagnostics");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const transformCallExpression_1 = require("./expressions/transformCallExpression");
const transformElementAccessExpression_1 = require("./expressions/transformElementAccessExpression");
const transformExpression_1 = require("./expressions/transformExpression");
const transformPropertyAccessExpression_1 = require("./expressions/transformPropertyAccessExpression");
const addOneIfArrayType_1 = require("../util/addOneIfArrayType");
const convertToIndexableExpression_1 = require("../util/convertToIndexableExpression");
const ensureTransformOrder_1 = require("../util/ensureTransformOrder");
const isMethod_1 = require("../util/isMethod");
const isUsedAsStatement_1 = require("../util/isUsedAsStatement");
const traversal_1 = require("../util/traversal");
const types_1 = require("../util/types");
const wrapReturnIfLuaTuple_1 = require("../util/wrapReturnIfLuaTuple");
const typescript_1 = __importDefault(require("typescript"));
var OptionalChainItemKind;
(function (OptionalChainItemKind) {
    OptionalChainItemKind[OptionalChainItemKind["PropertyAccess"] = 0] = "PropertyAccess";
    OptionalChainItemKind[OptionalChainItemKind["ElementAccess"] = 1] = "ElementAccess";
    OptionalChainItemKind[OptionalChainItemKind["Call"] = 2] = "Call";
    OptionalChainItemKind[OptionalChainItemKind["PropertyCall"] = 3] = "PropertyCall";
    OptionalChainItemKind[OptionalChainItemKind["ElementCall"] = 4] = "ElementCall";
})(OptionalChainItemKind || (OptionalChainItemKind = {}));
function createPropertyAccessItem(state, node) {
    return {
        node,
        kind: OptionalChainItemKind.PropertyAccess,
        optional: node.questionDotToken !== undefined,
        type: state.getType(node.expression),
        name: node.name.text,
    };
}
function createElementAccessItem(state, node) {
    return {
        node,
        kind: OptionalChainItemKind.ElementAccess,
        optional: node.questionDotToken !== undefined,
        type: state.getType(node.expression),
        expression: node.argumentExpression,
    };
}
function createCallItem(state, node) {
    return {
        node,
        kind: OptionalChainItemKind.Call,
        optional: node.questionDotToken !== undefined,
        type: state.getType(node.expression),
        args: node.arguments,
    };
}
function createPropertyCallItem(state, node, expression) {
    return {
        node,
        expression,
        kind: OptionalChainItemKind.PropertyCall,
        optional: expression.questionDotToken !== undefined,
        type: state.getType(node.expression),
        name: expression.name.text,
        callType: state.getType(node),
        callOptional: node.questionDotToken !== undefined,
        args: node.arguments,
    };
}
function createElementCallItem(state, node, expression) {
    return {
        node,
        expression,
        kind: OptionalChainItemKind.ElementCall,
        optional: expression.questionDotToken !== undefined,
        type: state.getType(expression),
        argumentExpression: expression.argumentExpression,
        callType: state.getType(node),
        callOptional: node.questionDotToken !== undefined,
        args: node.arguments,
    };
}
function flattenOptionalChain(state, expression) {
    const chain = new Array();
    while (true) {
        if (typescript_1.default.isPropertyAccessExpression(expression)) {
            chain.unshift(createPropertyAccessItem(state, expression));
            expression = expression.expression;
        }
        else if (typescript_1.default.isElementAccessExpression(expression)) {
            chain.unshift(createElementAccessItem(state, expression));
            expression = expression.expression;
        }
        else if (typescript_1.default.isCallExpression(expression)) {
            const subExp = (0, traversal_1.skipDownwards)(expression.expression);
            if (typescript_1.default.isPropertyAccessExpression(subExp)) {
                chain.unshift(createPropertyCallItem(state, expression, subExp));
                expression = subExp.expression;
            }
            else if (typescript_1.default.isElementAccessExpression(subExp)) {
                chain.unshift(createElementCallItem(state, expression, subExp));
                expression = subExp.expression;
            }
            else {
                chain.unshift(createCallItem(state, expression));
                expression = subExp;
            }
        }
        else {
            break;
        }
    }
    return { chain, expression };
}
exports.flattenOptionalChain = flattenOptionalChain;
function transformChainItem(state, baseExpression, item) {
    if (item.kind === OptionalChainItemKind.PropertyAccess) {
        return (0, transformPropertyAccessExpression_1.transformPropertyAccessExpressionInner)(state, item.node, baseExpression, item.name);
    }
    else if (item.kind === OptionalChainItemKind.ElementAccess) {
        return (0, transformElementAccessExpression_1.transformElementAccessExpressionInner)(state, item.node, baseExpression, item.expression);
    }
    else if (item.kind === OptionalChainItemKind.Call) {
        return (0, transformCallExpression_1.transformCallExpressionInner)(state, item.node, baseExpression, item.args);
    }
    else if (item.kind === OptionalChainItemKind.PropertyCall) {
        return (0, transformCallExpression_1.transformPropertyCallExpressionInner)(state, item.node, item.expression, baseExpression, item.name, item.args);
    }
    else {
        return (0, transformCallExpression_1.transformElementCallExpressionInner)(state, item.node, item.expression, baseExpression, item.argumentExpression, item.args);
    }
}
function createOrSetTempId(state, tempId, expression, node) {
    if (tempId === undefined) {
        tempId = state.pushToVar(expression, node.parent && typescript_1.default.isVariableDeclaration(node.parent) && typescript_1.default.isIdentifier(node.parent.name)
            ? node.parent.name.text
            : "result");
    }
    else {
        if (tempId !== expression) {
            state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: tempId,
                operator: "=",
                right: expression,
            }));
        }
    }
    return tempId;
}
function createNilCheck(tempId, statements) {
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
        condition: luau_ast_1.default.binary(tempId, "~=", luau_ast_1.default.nil()),
        statements,
        elseBody: luau_ast_1.default.list.make(),
    });
}
function isCompoundCall(item) {
    return item.kind === OptionalChainItemKind.PropertyCall || item.kind === OptionalChainItemKind.ElementCall;
}
function transformOptionalChainInner(state, chain, baseExpression, tempId = undefined, index = 0) {
    if (index >= chain.length)
        return baseExpression;
    const item = chain[index];
    if (item.optional || (isCompoundCall(item) && item.callOptional)) {
        let isMethodCall = false;
        let isSuperCall = false;
        let selfParam;
        if (isCompoundCall(item)) {
            isMethodCall = (0, isMethod_1.isMethod)(state, item.expression);
            isSuperCall = typescript_1.default.isSuperProperty(item.expression);
            if (item.callOptional && isMethodCall && !isSuperCall) {
                selfParam = state.pushToVar(baseExpression, "self");
                baseExpression = selfParam;
            }
            if (item.optional) {
                tempId = createOrSetTempId(state, tempId, baseExpression, chain[chain.length - 1].node);
                baseExpression = tempId;
            }
            if (item.callOptional) {
                if (item.kind === OptionalChainItemKind.PropertyCall) {
                    baseExpression = luau_ast_1.default.property((0, convertToIndexableExpression_1.convertToIndexableExpression)(baseExpression), item.name);
                }
                else {
                    const expType = state.getType(item.expression.expression);
                    baseExpression = luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                        expression: (0, convertToIndexableExpression_1.convertToIndexableExpression)(baseExpression),
                        index: (0, addOneIfArrayType_1.addOneIfArrayType)(state, expType, (0, transformExpression_1.transformExpression)(state, item.argumentExpression)),
                    });
                }
            }
        }
        const [result, prereqStatements] = state.capture(() => {
            tempId = createOrSetTempId(state, tempId, baseExpression, chain[chain.length - 1].node);
            const [newValue, ifStatements] = state.capture(() => {
                let newExpression;
                if (isCompoundCall(item) && item.callOptional) {
                    const expType = state.typeChecker.getNonOptionalType(state.getType(item.node.expression));
                    const symbol = (0, types_1.getFirstDefinedSymbol)(state, expType);
                    if (symbol) {
                        const macro = state.services.macroManager.getPropertyCallMacro(symbol);
                        if (macro) {
                            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noOptionalMacroCall(item.node));
                            return luau_ast_1.default.none();
                        }
                    }
                    const args = (0, ensureTransformOrder_1.ensureTransformOrder)(state, item.args);
                    if (isMethodCall) {
                        if (isSuperCall) {
                            args.unshift(luau_ast_1.default.globals.self);
                        }
                        else {
                            args.unshift(selfParam);
                        }
                    }
                    newExpression = (0, wrapReturnIfLuaTuple_1.wrapReturnIfLuaTuple)(state, item.node, luau_ast_1.default.call(tempId, args));
                }
                else {
                    newExpression = transformChainItem(state, tempId, item);
                }
                return transformOptionalChainInner(state, chain, newExpression, tempId, index + 1);
            });
            const isUsed = !luau_ast_1.default.isNone(newValue) && !(0, isUsedAsStatement_1.isUsedAsStatement)(item.node);
            if (tempId !== newValue && isUsed) {
                luau_ast_1.default.list.push(ifStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                    left: tempId,
                    operator: "=",
                    right: newValue,
                }));
            }
            else {
                if (luau_ast_1.default.isCall(newValue)) {
                    luau_ast_1.default.list.push(ifStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
                        expression: newValue,
                    }));
                }
            }
            state.prereq(createNilCheck(tempId, ifStatements));
            return isUsed ? tempId : luau_ast_1.default.none();
        });
        if (isCompoundCall(item) && item.optional && item.callOptional) {
            state.prereq(createNilCheck(tempId, prereqStatements));
        }
        else {
            state.prereqList(prereqStatements);
        }
        return result;
    }
    else {
        return transformOptionalChainInner(state, chain, transformChainItem(state, baseExpression, item), tempId, index + 1);
    }
}
function transformOptionalChain(state, node) {
    const { chain, expression } = flattenOptionalChain(state, node);
    return transformOptionalChainInner(state, chain, (0, transformExpression_1.transformExpression)(state, expression));
}
exports.transformOptionalChain = transformOptionalChain;
//# sourceMappingURL=transformOptionalChain.js.map