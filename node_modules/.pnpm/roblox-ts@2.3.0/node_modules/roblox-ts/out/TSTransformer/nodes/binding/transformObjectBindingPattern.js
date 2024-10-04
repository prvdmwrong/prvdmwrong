"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformObjectBindingPattern = void 0;
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformArrayBindingPattern_1 = require("./transformArrayBindingPattern");
const transformVariableStatement_1 = require("../statements/transformVariableStatement");
const transformInitializer_1 = require("../transformInitializer");
const objectAccessor_1 = require("../../util/binding/objectAccessor");
const validateNotAny_1 = require("../../util/validateNotAny");
const typescript_1 = __importDefault(require("typescript"));
function transformObjectBindingPattern(state, bindingPattern, parentId) {
    (0, validateNotAny_1.validateNotAnyType)(state, bindingPattern);
    for (const element of bindingPattern.elements) {
        if (element.dotDotDotToken) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noSpreadDestructuring(element));
            return;
        }
        const name = element.name;
        const prop = element.propertyName;
        if (typescript_1.default.isIdentifier(name)) {
            const value = (0, objectAccessor_1.objectAccessor)(state, parentId, state.getType(bindingPattern), prop !== null && prop !== void 0 ? prop : name);
            const id = (0, transformVariableStatement_1.transformVariable)(state, name, value);
            if (element.initializer) {
                state.prereq((0, transformInitializer_1.transformInitializer)(state, id, element.initializer));
            }
        }
        else {
            (0, assert_1.assert)(prop);
            const value = (0, objectAccessor_1.objectAccessor)(state, parentId, state.getType(bindingPattern), prop);
            const id = state.pushToVar(value, "binding");
            if (element.initializer) {
                state.prereq((0, transformInitializer_1.transformInitializer)(state, id, element.initializer));
            }
            if (typescript_1.default.isArrayBindingPattern(name)) {
                (0, transformArrayBindingPattern_1.transformArrayBindingPattern)(state, name, id);
            }
            else {
                transformObjectBindingPattern(state, name, id);
            }
        }
    }
}
exports.transformObjectBindingPattern = transformObjectBindingPattern;
//# sourceMappingURL=transformObjectBindingPattern.js.map