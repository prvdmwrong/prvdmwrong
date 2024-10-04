"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformArrayAssignmentPattern = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformObjectAssignmentPattern_1 = require("./transformObjectAssignmentPattern");
const transformInitializer_1 = require("../transformInitializer");
const transformWritable_1 = require("../transformWritable");
const getAccessorForBindingType_1 = require("../../util/binding/getAccessorForBindingType");
const getKindName_1 = require("../../util/getKindName");
const traversal_1 = require("../../util/traversal");
const typescript_1 = __importDefault(require("typescript"));
function transformArrayAssignmentPattern(state, assignmentPattern, parentId) {
    let index = 0;
    const idStack = new Array();
    const accessor = (0, getAccessorForBindingType_1.getAccessorForBindingType)(state, assignmentPattern, state.typeChecker.getTypeOfAssignmentPattern(assignmentPattern));
    for (let element of assignmentPattern.elements) {
        if (typescript_1.default.isOmittedExpression(element)) {
            accessor(state, parentId, index, idStack, true);
        }
        else if (typescript_1.default.isSpreadElement(element)) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noSpreadDestructuring(element));
        }
        else {
            let initializer;
            if (typescript_1.default.isBinaryExpression(element)) {
                initializer = (0, traversal_1.skipDownwards)(element.right);
                element = (0, traversal_1.skipDownwards)(element.left);
            }
            const value = accessor(state, parentId, index, idStack, false);
            if (typescript_1.default.isIdentifier(element) ||
                typescript_1.default.isElementAccessExpression(element) ||
                typescript_1.default.isPropertyAccessExpression(element)) {
                const id = (0, transformWritable_1.transformWritableExpression)(state, element, initializer !== undefined);
                state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                    left: id,
                    operator: "=",
                    right: value,
                }));
                if (initializer) {
                    state.prereq((0, transformInitializer_1.transformInitializer)(state, id, initializer));
                }
            }
            else if (typescript_1.default.isArrayLiteralExpression(element)) {
                const id = state.pushToVar(value, "binding");
                if (initializer) {
                    state.prereq((0, transformInitializer_1.transformInitializer)(state, id, initializer));
                }
                transformArrayAssignmentPattern(state, element, id);
            }
            else if (typescript_1.default.isObjectLiteralExpression(element)) {
                const id = state.pushToVar(value, "binding");
                if (initializer) {
                    state.prereq((0, transformInitializer_1.transformInitializer)(state, id, initializer));
                }
                (0, transformObjectAssignmentPattern_1.transformObjectAssignmentPattern)(state, element, id);
            }
            else {
                (0, assert_1.assert)(false, `transformArrayAssignmentPattern invalid element: ${(0, getKindName_1.getKindName)(element.kind)}`);
            }
        }
        index++;
    }
}
exports.transformArrayAssignmentPattern = transformArrayAssignmentPattern;
//# sourceMappingURL=transformArrayAssignmentPattern.js.map