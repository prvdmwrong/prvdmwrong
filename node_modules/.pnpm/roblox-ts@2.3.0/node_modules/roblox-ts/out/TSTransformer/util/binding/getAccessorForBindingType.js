"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getAccessorForBindingType = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const types_1 = require("../types");
const typescript_1 = __importDefault(require("typescript"));
function peek(array) {
    return array[array.length - 1];
}
const arrayAccessor = (state, parentId, index) => {
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
        expression: parentId,
        index: luau_ast_1.default.number(index + 1),
    });
};
const stringAccessor = (state, parentId, index, idStack, isOmitted) => {
    let id;
    if (idStack.length === 0) {
        id = state.pushToVar(luau_ast_1.default.call(luau_ast_1.default.globals.string.gmatch, [parentId, luau_ast_1.default.globals.utf8.charpattern]), "matcher");
        idStack.push(id);
    }
    else {
        id = idStack[0];
    }
    const callExp = luau_ast_1.default.call(id);
    if (isOmitted) {
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
            expression: callExp,
        }));
        return luau_ast_1.default.none();
    }
    else {
        return callExp;
    }
};
const setAccessor = (state, parentId, index, idStack, isOmitted) => {
    const args = [parentId];
    const lastId = peek(idStack);
    if (lastId) {
        args.push(lastId);
    }
    const callExp = luau_ast_1.default.call(luau_ast_1.default.globals.next, args);
    if (isOmitted) {
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
            expression: callExp,
        }));
        return luau_ast_1.default.none();
    }
    else {
        const id = state.pushToVar(callExp, "value");
        idStack.push(id);
        return id;
    }
};
const mapAccessor = (state, parentId, index, idStack) => {
    const args = [parentId];
    const lastId = peek(idStack);
    if (lastId) {
        args.push(lastId);
    }
    const keyId = luau_ast_1.default.tempId("k");
    const valueId = luau_ast_1.default.tempId("v");
    const ids = luau_ast_1.default.list.make(keyId, valueId);
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
        left: ids,
        right: luau_ast_1.default.call(luau_ast_1.default.globals.next, args),
    }));
    idStack.push(keyId);
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Array, { members: ids });
};
const iterableFunctionLuaTupleAccessor = (state, parentId, index, idStack, isOmitted) => {
    const callExp = luau_ast_1.default.call(parentId);
    if (isOmitted) {
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
            expression: callExp,
        }));
        return luau_ast_1.default.none();
    }
    else {
        return luau_ast_1.default.array([callExp]);
    }
};
const iterableFunctionAccessor = (state, parentId, index, idStack, isOmitted) => {
    const callExp = luau_ast_1.default.call(parentId);
    if (isOmitted) {
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
            expression: callExp,
        }));
        return luau_ast_1.default.none();
    }
    else {
        return callExp;
    }
};
const iterAccessor = (state, parentId, index, idStack, isOmitted) => {
    const callExp = luau_ast_1.default.call(luau_ast_1.default.property(parentId, "next"));
    if (isOmitted) {
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, { expression: callExp }));
        return luau_ast_1.default.none();
    }
    else {
        return luau_ast_1.default.property(callExp, "value");
    }
};
function getAccessorForBindingType(state, node, type) {
    if ((0, types_1.isDefinitelyType)(type, (0, types_1.isArrayType)(state))) {
        return arrayAccessor;
    }
    else if ((0, types_1.isDefinitelyType)(type, types_1.isStringType)) {
        return stringAccessor;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isSetType)(state))) {
        return setAccessor;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isMapType)(state))) {
        return mapAccessor;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isIterableFunctionLuaTupleType)(state))) {
        return iterableFunctionLuaTupleAccessor;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isIterableFunctionType)(state))) {
        return iterableFunctionAccessor;
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isIterableType)(state))) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noIterableIteration(node));
        return () => luau_ast_1.default.none();
    }
    else if ((0, types_1.isDefinitelyType)(type, (0, types_1.isGeneratorType)(state)) ||
        (0, types_1.isDefinitelyType)(type, types_1.isObjectType) ||
        typescript_1.default.isThis(node)) {
        return iterAccessor;
    }
    (0, assert_1.assert)(false, `Destructuring not supported for type: ${state.typeChecker.typeToString(type)}`);
}
exports.getAccessorForBindingType = getAccessorForBindingType;
//# sourceMappingURL=getAccessorForBindingType.js.map