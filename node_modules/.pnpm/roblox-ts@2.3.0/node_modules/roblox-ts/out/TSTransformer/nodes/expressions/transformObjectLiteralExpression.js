"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformObjectLiteralExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformExpression_1 = require("./transformExpression");
const transformMethodDeclaration_1 = require("../transformMethodDeclaration");
const transformPropertyName_1 = require("../transformPropertyName");
const createTruthinessChecks_1 = require("../../util/createTruthinessChecks");
const pointer_1 = require("../../util/pointer");
const types_1 = require("../../util/types");
const validateMethodAssignment_1 = require("../../util/validateMethodAssignment");
const typescript_1 = __importDefault(require("typescript"));
function transformPropertyAssignment(state, ptr, name, initializer) {
    let [left, leftPrereqs] = state.capture(() => (0, transformPropertyName_1.transformPropertyName)(state, name));
    const [right, rightPrereqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, initializer));
    if (!luau_ast_1.default.list.isEmpty(leftPrereqs) || !luau_ast_1.default.list.isEmpty(rightPrereqs)) {
        (0, pointer_1.disableMapInline)(state, ptr);
        state.prereqList(leftPrereqs);
        left = state.pushToVar(left, "left");
    }
    state.prereqList(rightPrereqs);
    (0, pointer_1.assignToMapPointer)(state, ptr, left, right);
}
function transformSpreadAssignment(state, ptr, property) {
    const expType = state.typeChecker.getNonOptionalType(state.getType(property.expression));
    const symbol = (0, types_1.getFirstDefinedSymbol)(state, expType);
    if (symbol && state.services.macroManager.isMacroOnlyClass(symbol)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noMacroObjectSpread(property));
    }
    const type = state.getType(property.expression);
    const definitelyObject = (0, types_1.isDefinitelyType)(type, types_1.isObjectType);
    if (definitelyObject && luau_ast_1.default.isMap(ptr.value) && luau_ast_1.default.list.isEmpty(ptr.value.fields)) {
        ptr.value = state.pushToVar(luau_ast_1.default.call(luau_ast_1.default.globals.table.clone, [(0, transformExpression_1.transformExpression)(state, property.expression)]), ptr.name);
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
            expression: luau_ast_1.default.call(luau_ast_1.default.globals.setmetatable, [ptr.value, luau_ast_1.default.nil()]),
        }));
        return;
    }
    (0, pointer_1.disableMapInline)(state, ptr);
    let spreadExp = (0, transformExpression_1.transformExpression)(state, property.expression);
    if (!definitelyObject) {
        spreadExp = state.pushToVarIfComplex(spreadExp, "spread");
    }
    const keyId = luau_ast_1.default.tempId("k");
    const valueId = luau_ast_1.default.tempId("v");
    let statement = luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ForStatement, {
        ids: luau_ast_1.default.list.make(keyId, valueId),
        expression: spreadExp,
        statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                expression: ptr.value,
                index: keyId,
            }),
            operator: "=",
            right: valueId,
        })),
    });
    if (!definitelyObject) {
        statement = luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
            condition: (0, createTruthinessChecks_1.createTruthinessChecks)(state, spreadExp, property.expression),
            statements: luau_ast_1.default.list.make(statement),
            elseBody: luau_ast_1.default.list.make(),
        });
    }
    state.prereq(statement);
}
function transformObjectLiteralExpression(state, node) {
    const ptr = (0, pointer_1.createMapPointer)("object");
    for (const property of node.properties) {
        (0, validateMethodAssignment_1.validateMethodAssignment)(state, property);
        if (typescript_1.default.isPropertyAssignment(property)) {
            if (typescript_1.default.isPrivateIdentifier(property.name)) {
                DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noPrivateIdentifier(property.name));
                continue;
            }
            transformPropertyAssignment(state, ptr, property.name, property.initializer);
        }
        else if (typescript_1.default.isShorthandPropertyAssignment(property)) {
            transformPropertyAssignment(state, ptr, property.name, property.name);
        }
        else if (typescript_1.default.isSpreadAssignment(property)) {
            transformSpreadAssignment(state, ptr, property);
        }
        else if (typescript_1.default.isMethodDeclaration(property)) {
            state.prereqList((0, transformMethodDeclaration_1.transformMethodDeclaration)(state, property, ptr));
        }
        else {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noGetterSetter(property));
        }
    }
    return ptr.value;
}
exports.transformObjectLiteralExpression = transformObjectLiteralExpression;
//# sourceMappingURL=transformObjectLiteralExpression.js.map