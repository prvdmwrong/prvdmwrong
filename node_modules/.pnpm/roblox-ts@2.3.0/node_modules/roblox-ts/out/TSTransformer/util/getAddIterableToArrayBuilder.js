"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getAddIterableToArrayBuilder = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../Shared/diagnostics");
const assert_1 = require("../../Shared/util/assert");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const convertToIndexableExpression_1 = require("./convertToIndexableExpression");
const types_1 = require("./types");
const valueToIdStr_1 = require("./valueToIdStr");
const addArray = (state, expression, arrayId, lengthId, amtElementsSinceUpdate, shouldUpdateLengthId) => {
    const result = luau_ast_1.default.list.make();
    const inputArray = state.pushToVarIfNonId(expression, "array");
    let inputLength = luau_ast_1.default.unary("#", inputArray);
    if (shouldUpdateLengthId) {
        inputLength = state.pushToVar(inputLength, (0, valueToIdStr_1.valueToIdStr)(inputArray) + "Length");
    }
    luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
        expression: luau_ast_1.default.call(luau_ast_1.default.globals.table.move, [
            inputArray,
            luau_ast_1.default.number(1),
            inputLength,
            luau_ast_1.default.binary(lengthId, "+", luau_ast_1.default.number(amtElementsSinceUpdate + 1)),
            arrayId,
        ]),
    }));
    if (shouldUpdateLengthId) {
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: inputLength,
        }));
    }
    return result;
};
const addString = (state, expression, arrayId, lengthId, amtElementsSinceUpdate) => {
    const result = luau_ast_1.default.list.make();
    if (amtElementsSinceUpdate > 0) {
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(amtElementsSinceUpdate),
        }));
    }
    const valueId = luau_ast_1.default.tempId("char");
    luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ForStatement, {
        ids: luau_ast_1.default.list.make(valueId),
        expression: luau_ast_1.default.call(luau_ast_1.default.globals.string.gmatch, [expression, luau_ast_1.default.globals.utf8.charpattern]),
        statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(1),
        }), luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                expression: arrayId,
                index: lengthId,
            }),
            operator: "=",
            right: valueId,
        })),
    }));
    return result;
};
const addSet = (state, expression, arrayId, lengthId, amtElementsSinceUpdate) => {
    const result = luau_ast_1.default.list.make();
    if (amtElementsSinceUpdate > 0) {
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(amtElementsSinceUpdate),
        }));
    }
    const valueId = luau_ast_1.default.tempId("v");
    luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ForStatement, {
        ids: luau_ast_1.default.list.make(valueId),
        expression,
        statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(1),
        }), luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                expression: arrayId,
                index: lengthId,
            }),
            operator: "=",
            right: valueId,
        })),
    }));
    return result;
};
const addMap = (state, expression, arrayId, lengthId, amtElementsSinceUpdate) => {
    const result = luau_ast_1.default.list.make();
    if (amtElementsSinceUpdate > 0) {
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(amtElementsSinceUpdate),
        }));
    }
    const keyId = luau_ast_1.default.tempId("k");
    const valueId = luau_ast_1.default.tempId("v");
    luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ForStatement, {
        ids: luau_ast_1.default.list.make(keyId, valueId),
        expression,
        statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(1),
        }), luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                expression: arrayId,
                index: lengthId,
            }),
            operator: "=",
            right: luau_ast_1.default.array([keyId, valueId]),
        })),
    }));
    return result;
};
const addIterableFunction = (state, expression, arrayId, lengthId, amtElementsSinceUpdate) => {
    const result = luau_ast_1.default.list.make();
    if (amtElementsSinceUpdate > 0) {
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(amtElementsSinceUpdate),
        }));
    }
    const valueId = luau_ast_1.default.tempId("result");
    luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ForStatement, {
        ids: luau_ast_1.default.list.make(valueId),
        expression,
        statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(1),
        }), luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                expression: arrayId,
                index: lengthId,
            }),
            operator: "=",
            right: valueId,
        })),
    }));
    return result;
};
const addIterableFunctionLuaTuple = (state, expression, arrayId, lengthId, amtElementsSinceUpdate) => {
    const result = luau_ast_1.default.list.make();
    if (amtElementsSinceUpdate > 0) {
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(amtElementsSinceUpdate),
        }));
    }
    const iterFuncId = state.pushToVar(expression, "iterFunc");
    const valueId = luau_ast_1.default.tempId("results");
    luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.WhileStatement, {
        condition: luau_ast_1.default.bool(true),
        statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: valueId,
            right: luau_ast_1.default.array([luau_ast_1.default.call(iterFuncId)]),
        }), luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
            condition: luau_ast_1.default.binary(luau_ast_1.default.unary("#", valueId), "==", luau_ast_1.default.number(0)),
            statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.BreakStatement, {})),
            elseBody: luau_ast_1.default.list.make(),
        }), luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(1),
        }), luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                expression: arrayId,
                index: lengthId,
            }),
            operator: "=",
            right: valueId,
        })),
    }));
    return result;
};
const addGenerator = (state, expression, arrayId, lengthId, amtElementsSinceUpdate) => {
    const result = luau_ast_1.default.list.make();
    if (amtElementsSinceUpdate > 0) {
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(amtElementsSinceUpdate),
        }));
    }
    const iterId = luau_ast_1.default.tempId("result");
    luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ForStatement, {
        ids: luau_ast_1.default.list.make(iterId),
        expression: luau_ast_1.default.property((0, convertToIndexableExpression_1.convertToIndexableExpression)(expression), "next"),
        statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
            condition: luau_ast_1.default.property(iterId, "done"),
            statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.BreakStatement, {})),
            elseBody: luau_ast_1.default.list.make(),
        }), luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: lengthId,
            operator: "+=",
            right: luau_ast_1.default.number(1),
        }), luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                expression: arrayId,
                index: lengthId,
            }),
            operator: "=",
            right: luau_ast_1.default.property(iterId, "value"),
        })),
    }));
    return result;
};
function getAddIterableToArrayBuilder(state, node, type) {
    if ((0, types_1.isDefinitelyType)(type, (0, types_1.isArrayType)(state))) {
        return addArray;
    }
    else if ((0, types_1.isDefinitelyType)(type, types_1.isStringType)) {
        return addString;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isSetType)(state))) {
        return addSet;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isMapType)(state))) {
        return addMap;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isIterableFunctionLuaTupleType)(state))) {
        return addIterableFunctionLuaTuple;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isIterableFunctionType)(state))) {
        return addIterableFunction;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isGeneratorType)(state))) {
        return addGenerator;
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
        (0, assert_1.assert)(false, `Iteration type not implemented: ${state.typeChecker.typeToString(type)}`);
    }
}
exports.getAddIterableToArrayBuilder = getAddIterableToArrayBuilder;
//# sourceMappingURL=getAddIterableToArrayBuilder.js.map