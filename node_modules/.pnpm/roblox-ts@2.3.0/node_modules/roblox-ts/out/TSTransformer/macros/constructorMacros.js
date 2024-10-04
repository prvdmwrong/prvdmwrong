"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CONSTRUCTOR_MACROS = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const assert_1 = require("../../Shared/util/assert");
const transformExpression_1 = require("../nodes/expressions/transformExpression");
const ensureTransformOrder_1 = require("../util/ensureTransformOrder");
const typescript_1 = __importDefault(require("typescript"));
function wrapWeak(state, node, macro) {
    return luau_ast_1.default.call(luau_ast_1.default.globals.setmetatable, [
        macro(state, node),
        luau_ast_1.default.map([[luau_ast_1.default.strings.__mode, luau_ast_1.default.strings.k]]),
    ]);
}
const ArrayConstructor = (state, node) => {
    if (node.arguments && node.arguments.length > 0) {
        const args = (0, ensureTransformOrder_1.ensureTransformOrder)(state, node.arguments);
        return luau_ast_1.default.call(luau_ast_1.default.globals.table.create, args);
    }
    return luau_ast_1.default.array();
};
const SetConstructor = (state, node) => {
    if (!node.arguments || node.arguments.length === 0) {
        return luau_ast_1.default.set();
    }
    const arg = node.arguments[0];
    if (typescript_1.default.isArrayLiteralExpression(arg) && !arg.elements.some(typescript_1.default.isSpreadElement)) {
        return luau_ast_1.default.set((0, ensureTransformOrder_1.ensureTransformOrder)(state, arg.elements));
    }
    else {
        const id = state.pushToVar(luau_ast_1.default.set(), "set");
        const valueId = luau_ast_1.default.tempId("v");
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ForStatement, {
            ids: luau_ast_1.default.list.make(luau_ast_1.default.tempId(), valueId),
            expression: (0, transformExpression_1.transformExpression)(state, arg),
            statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                    expression: id,
                    index: valueId,
                }),
                operator: "=",
                right: luau_ast_1.default.bool(true),
            })),
        }));
        return id;
    }
};
const MapConstructor = (state, node) => {
    if (!node.arguments || node.arguments.length === 0) {
        return luau_ast_1.default.map();
    }
    const arg = node.arguments[0];
    const transformed = (0, transformExpression_1.transformExpression)(state, arg);
    if (luau_ast_1.default.isArray(transformed) && luau_ast_1.default.list.every(transformed.members, member => luau_ast_1.default.isArray(member))) {
        const elements = luau_ast_1.default.list.toArray(transformed.members).map(e => {
            (0, assert_1.assert)(luau_ast_1.default.isArray(e) && luau_ast_1.default.list.isNonEmpty(e.members));
            return [e.members.head.value, e.members.head.next.value];
        });
        return luau_ast_1.default.map(elements);
    }
    else {
        const id = state.pushToVar(luau_ast_1.default.map(), "map");
        const valueId = luau_ast_1.default.tempId("v");
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ForStatement, {
            ids: luau_ast_1.default.list.make(luau_ast_1.default.tempId(), valueId),
            expression: transformed,
            statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                    expression: id,
                    index: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                        expression: valueId,
                        index: luau_ast_1.default.number(1),
                    }),
                }),
                operator: "=",
                right: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                    expression: valueId,
                    index: luau_ast_1.default.number(2),
                }),
            })),
        }));
        return id;
    }
};
exports.CONSTRUCTOR_MACROS = {
    ArrayConstructor,
    SetConstructor,
    MapConstructor,
    WeakSetConstructor: (state, node) => wrapWeak(state, node, SetConstructor),
    WeakMapConstructor: (state, node) => wrapWeak(state, node, MapConstructor),
    ReadonlyMapConstructor: MapConstructor,
    ReadonlySetConstructor: SetConstructor,
};
//# sourceMappingURL=constructorMacros.js.map