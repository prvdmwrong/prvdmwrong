"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.solveTempIds = void 0;
const LuauAST_1 = __importDefault(require("../LuauAST"));
const assert_1 = require("../LuauAST/util/assert");
const visit_1 = require("./util/visit");
function isFullyScopedNode(node) {
    return LuauAST_1.default.isForStatement(node) || LuauAST_1.default.isNumericForStatement(node) || LuauAST_1.default.isFunctionLike(node);
}
function isScopeEdge(node, edge) {
    var _a, _b;
    if (node.parent) {
        if (LuauAST_1.default.hasStatements(node.parent)) {
            if (node === ((_a = node.parent.statements[edge]) === null || _a === void 0 ? void 0 : _a.value)) {
                return true;
            }
        }
        if (LuauAST_1.default.isIfStatement(node.parent) &&
            LuauAST_1.default.list.isList(node.parent.elseBody) &&
            node === ((_b = node.parent.elseBody[edge]) === null || _b === void 0 ? void 0 : _b.value)) {
            return true;
        }
    }
    return false;
}
const isScopeStart = (node) => isScopeEdge(node, "head");
const isScopeEnd = (node) => isScopeEdge(node, "tail");
function createScope(parent) {
    return {
        ids: new Set(),
        lastTry: new Map(),
        parent,
    };
}
function scopeHasId(scope, id) {
    if (scope.ids.has(id)) {
        return true;
    }
    if (scope.parent) {
        return scopeHasId(scope.parent, id);
    }
    return false;
}
function solveTempIds(state, ast) {
    var _a;
    const tempIdsToProcess = new Array();
    const nodesToScopes = new Map();
    const scopeStack = [createScope()];
    function pushScopeStack() {
        scopeStack.push(createScope(peekScopeStack()));
    }
    function popScopeStack() {
        return scopeStack.pop();
    }
    function peekScopeStack() {
        const scope = scopeStack[scopeStack.length - 1];
        (0, assert_1.assert)(scope);
        return scope;
    }
    function registerId(name) {
        peekScopeStack().ids.add(name);
    }
    (0, visit_1.visit)(ast, {
        before: node => {
            if (isFullyScopedNode(node))
                pushScopeStack();
            if (isScopeStart(node))
                pushScopeStack();
            if (LuauAST_1.default.isTemporaryIdentifier(node)) {
                nodesToScopes.set(node, peekScopeStack());
                tempIdsToProcess.push(node);
            }
            else if (LuauAST_1.default.isVariableDeclaration(node)) {
                if (LuauAST_1.default.list.isList(node.left)) {
                    LuauAST_1.default.list.forEach(node.left, node => {
                        if (LuauAST_1.default.isIdentifier(node)) {
                            registerId(node.name);
                        }
                    });
                }
                else if (LuauAST_1.default.isIdentifier(node.left)) {
                    registerId(node.left.name);
                }
            }
            else if (LuauAST_1.default.isFunctionLike(node)) {
                LuauAST_1.default.list.forEach(node.parameters, node => {
                    if (LuauAST_1.default.isIdentifier(node)) {
                        registerId(node.name);
                    }
                });
            }
        },
        after: node => {
            if (isFullyScopedNode(node))
                popScopeStack();
            if (isScopeEnd(node))
                popScopeStack();
        },
    });
    for (const tempId of tempIdsToProcess) {
        if (state.seenTempNodes.get(tempId.id) === undefined) {
            const scope = nodesToScopes.get(tempId);
            (0, assert_1.assert)(scope);
            const seperator = tempId.name === "" ? "" : "_";
            let input = `_${tempId.name}`;
            let i = (_a = scope.lastTry.get(input)) !== null && _a !== void 0 ? _a : 1;
            while (scopeHasId(scope, input)) {
                input = `_${tempId.name}${seperator}${i++}`;
            }
            scope.lastTry.set(input, i);
            scope.ids.add(input);
            state.seenTempNodes.set(tempId.id, input);
        }
    }
}
exports.solveTempIds = solveTempIds;
//# sourceMappingURL=solveTempIds.js.map