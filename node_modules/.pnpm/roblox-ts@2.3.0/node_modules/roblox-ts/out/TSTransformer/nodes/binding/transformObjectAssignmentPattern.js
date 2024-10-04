"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformObjectAssignmentPattern = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformArrayAssignmentPattern_1 = require("./transformArrayAssignmentPattern");
const transformInitializer_1 = require("../transformInitializer");
const transformWritable_1 = require("../transformWritable");
const objectAccessor_1 = require("../../util/binding/objectAccessor");
const getKindName_1 = require("../../util/getKindName");
const traversal_1 = require("../../util/traversal");
const typescript_1 = __importDefault(require("typescript"));
function transformObjectAssignmentPattern(state, assignmentPattern, parentId) {
    for (const property of assignmentPattern.properties) {
        if (typescript_1.default.isShorthandPropertyAssignment(property)) {
            const name = property.name;
            const value = (0, objectAccessor_1.objectAccessor)(state, parentId, state.typeChecker.getTypeOfAssignmentPattern(assignmentPattern), name);
            const id = (0, transformWritable_1.transformWritableExpression)(state, name, property.objectAssignmentInitializer !== undefined);
            state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: id,
                operator: "=",
                right: value,
            }));
            (0, assert_1.assert)(luau_ast_1.default.isAnyIdentifier(id));
            if (property.objectAssignmentInitializer) {
                state.prereq((0, transformInitializer_1.transformInitializer)(state, id, property.objectAssignmentInitializer));
            }
        }
        else if (typescript_1.default.isSpreadAssignment(property)) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noSpreadDestructuring(property));
            return;
        }
        else if (typescript_1.default.isPropertyAssignment(property)) {
            const name = property.name;
            let init = property.initializer;
            let initializer;
            if (typescript_1.default.isBinaryExpression(property.initializer)) {
                initializer = (0, traversal_1.skipDownwards)(property.initializer.right);
                init = (0, traversal_1.skipDownwards)(property.initializer.left);
            }
            const value = (0, objectAccessor_1.objectAccessor)(state, parentId, state.typeChecker.getTypeOfAssignmentPattern(assignmentPattern), name);
            if (typescript_1.default.isIdentifier(init) || typescript_1.default.isElementAccessExpression(init) || typescript_1.default.isPropertyAccessExpression(init)) {
                const id = (0, transformWritable_1.transformWritableExpression)(state, init, initializer !== undefined);
                state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                    left: id,
                    operator: "=",
                    right: value,
                }));
                if (initializer) {
                    state.prereq((0, transformInitializer_1.transformInitializer)(state, id, initializer));
                }
            }
            else if (typescript_1.default.isArrayLiteralExpression(init)) {
                const id = state.pushToVar(value, "binding");
                if (initializer) {
                    state.prereq((0, transformInitializer_1.transformInitializer)(state, id, initializer));
                }
                (0, assert_1.assert)(typescript_1.default.isIdentifier(name));
                (0, transformArrayAssignmentPattern_1.transformArrayAssignmentPattern)(state, init, id);
            }
            else if (typescript_1.default.isObjectLiteralExpression(init)) {
                const id = state.pushToVar(value, "binding");
                if (initializer) {
                    state.prereq((0, transformInitializer_1.transformInitializer)(state, id, initializer));
                }
                transformObjectAssignmentPattern(state, init, id);
            }
            else {
                (0, assert_1.assert)(false, `transformObjectAssignmentPattern invalid initializer: ${(0, getKindName_1.getKindName)(init.kind)}`);
            }
        }
        else {
            (0, assert_1.assert)(false, `transformObjectAssignmentPattern invalid property: ${(0, getKindName_1.getKindName)(property.kind)}`);
        }
    }
}
exports.transformObjectAssignmentPattern = transformObjectAssignmentPattern;
//# sourceMappingURL=transformObjectAssignmentPattern.js.map