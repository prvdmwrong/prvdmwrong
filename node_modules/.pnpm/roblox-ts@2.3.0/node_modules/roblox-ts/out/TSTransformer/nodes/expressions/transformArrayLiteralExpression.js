"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformArrayLiteralExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const assert_1 = require("../../../Shared/util/assert");
const transformExpression_1 = require("./transformExpression");
const ensureTransformOrder_1 = require("../../util/ensureTransformOrder");
const getAddIterableToArrayBuilder_1 = require("../../util/getAddIterableToArrayBuilder");
const pointer_1 = require("../../util/pointer");
const typescript_1 = __importDefault(require("typescript"));
function transformArrayLiteralExpression(state, node) {
    if (!node.elements.find(element => typescript_1.default.isSpreadElement(element))) {
        return luau_ast_1.default.array((0, ensureTransformOrder_1.ensureTransformOrder)(state, node.elements));
    }
    const ptr = (0, pointer_1.createArrayPointer)("array");
    const lengthId = luau_ast_1.default.tempId("length");
    let lengthInitialized = false;
    let amtElementsSinceUpdate = 0;
    function updateLengthId() {
        const right = luau_ast_1.default.unary("#", ptr.value);
        if (lengthInitialized) {
            state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: lengthId,
                operator: "=",
                right,
            }));
        }
        else {
            state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
                left: lengthId,
                right,
            }));
            lengthInitialized = true;
        }
        amtElementsSinceUpdate = 0;
    }
    for (let i = 0; i < node.elements.length; i++) {
        const element = node.elements[i];
        if (typescript_1.default.isSpreadElement(element)) {
            if (luau_ast_1.default.isArray(ptr.value)) {
                (0, pointer_1.disableArrayInline)(state, ptr);
                updateLengthId();
            }
            (0, assert_1.assert)(luau_ast_1.default.isAnyIdentifier(ptr.value));
            const type = state.getType(element.expression);
            const addIterableToArrayBuilder = (0, getAddIterableToArrayBuilder_1.getAddIterableToArrayBuilder)(state, element.expression, type);
            const spreadExp = (0, transformExpression_1.transformExpression)(state, element.expression);
            const shouldUpdateLengthId = i < node.elements.length - 1;
            state.prereqList(addIterableToArrayBuilder(state, spreadExp, ptr.value, lengthId, amtElementsSinceUpdate, shouldUpdateLengthId));
        }
        else {
            const [expression, prereqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, element));
            if (luau_ast_1.default.isArray(ptr.value) && !luau_ast_1.default.list.isEmpty(prereqs)) {
                (0, pointer_1.disableArrayInline)(state, ptr);
                updateLengthId();
            }
            if (luau_ast_1.default.isArray(ptr.value)) {
                luau_ast_1.default.list.push(ptr.value.members, expression);
            }
            else {
                state.prereqList(prereqs);
                state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                    left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                        expression: ptr.value,
                        index: luau_ast_1.default.binary(lengthId, "+", luau_ast_1.default.number(amtElementsSinceUpdate + 1)),
                    }),
                    operator: "=",
                    right: expression,
                }));
            }
            amtElementsSinceUpdate++;
        }
    }
    return ptr.value;
}
exports.transformArrayLiteralExpression = transformArrayLiteralExpression;
//# sourceMappingURL=transformArrayLiteralExpression.js.map