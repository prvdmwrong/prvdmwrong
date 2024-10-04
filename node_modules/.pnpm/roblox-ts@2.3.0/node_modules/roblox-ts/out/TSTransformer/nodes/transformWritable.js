"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformWritableAssignment = exports.transformWritableExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../Shared/diagnostics");
const assert_1 = require("../../Shared/util/assert");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const transformExpression_1 = require("./expressions/transformExpression");
const addOneIfArrayType_1 = require("../util/addOneIfArrayType");
const convertToIndexableExpression_1 = require("../util/convertToIndexableExpression");
const ensureTransformOrder_1 = require("../util/ensureTransformOrder");
const traversal_1 = require("../util/traversal");
const typescript_1 = __importDefault(require("typescript"));
function transformWritableExpression(state, node, readAfterWrite) {
    if (typescript_1.default.isPrototypeAccess(node)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noPrototype(node));
    }
    if (typescript_1.default.isPropertyAccessExpression(node)) {
        const expression = (0, transformExpression_1.transformExpression)(state, node.expression);
        return luau_ast_1.default.property(readAfterWrite ? state.pushToVarIfNonId(expression, "exp") : (0, convertToIndexableExpression_1.convertToIndexableExpression)(expression), node.name.text);
    }
    else if (typescript_1.default.isElementAccessExpression(node)) {
        const [expression, index] = (0, ensureTransformOrder_1.ensureTransformOrder)(state, [node.expression, node.argumentExpression]);
        const indexExp = (0, addOneIfArrayType_1.addOneIfArrayType)(state, state.getType(node.expression), index);
        return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
            expression: readAfterWrite
                ? state.pushToVarIfNonId(expression, "exp")
                : (0, convertToIndexableExpression_1.convertToIndexableExpression)(expression),
            index: readAfterWrite ? state.pushToVarIfComplex(indexExp, "index") : indexExp,
        });
    }
    else {
        const transformed = (0, transformExpression_1.transformExpression)(state, (0, traversal_1.skipDownwards)(node));
        (0, assert_1.assert)(luau_ast_1.default.isWritableExpression(transformed));
        return transformed;
    }
}
exports.transformWritableExpression = transformWritableExpression;
function transformWritableAssignment(state, writeNode, valueNode, readAfterWrite = false, readBeforeWrite = false) {
    const writable = transformWritableExpression(state, writeNode, readAfterWrite);
    const [value, prereqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, valueNode));
    const readable = !readBeforeWrite || luau_ast_1.default.list.isEmpty(prereqs) ? writable : state.pushToVar(writable, "readable");
    state.prereqList(prereqs);
    return { writable, readable, value };
}
exports.transformWritableAssignment = transformWritableAssignment;
//# sourceMappingURL=transformWritable.js.map