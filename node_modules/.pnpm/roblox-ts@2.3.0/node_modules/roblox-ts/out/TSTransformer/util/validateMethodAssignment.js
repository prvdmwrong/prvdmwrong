"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateMethodAssignment = void 0;
const diagnostics_1 = require("../../Shared/diagnostics");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const isMethod_1 = require("./isMethod");
const types_1 = require("./types");
const typescript_1 = __importDefault(require("typescript"));
function hasCallSignatures(type) {
    let hasCallSignatures = false;
    (0, types_1.walkTypes)(type, t => {
        hasCallSignatures || (hasCallSignatures = t.getCallSignatures().length > 0);
    });
    return hasCallSignatures;
}
function validateTypes(state, node, baseType, assignmentType) {
    if (hasCallSignatures(baseType) && hasCallSignatures(assignmentType)) {
        const assignmentIsMethod = (0, isMethod_1.isMethodFromType)(state, node, assignmentType);
        if ((0, isMethod_1.isMethodFromType)(state, node, baseType) !== assignmentIsMethod) {
            if (assignmentIsMethod) {
                DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.expectedMethodGotFunction(node));
            }
            else {
                DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.expectedFunctionGotMethod(node));
            }
        }
    }
}
function validateObjectLiteralElement(state, node) {
    const type = state.getType(node);
    const contextualType = state.typeChecker.getContextualTypeForObjectLiteralElement(node);
    if (contextualType && contextualType !== type) {
        validateTypes(state, node, type, contextualType);
    }
}
function validateHeritageClause(state, node, typeNode) {
    const name = typescript_1.default.getPropertyNameForPropertyNameNode(node.name);
    if (!name)
        return;
    const type = state.getType(node);
    const propertyType = state.typeChecker.getTypeOfPropertyOfType(state.getType(typeNode), name);
    if (!propertyType)
        return;
    validateTypes(state, node, type, propertyType);
}
function validateSpread(state, node) {
    const type = state.getType(node.expression);
    const contextualType = state.typeChecker.getContextualType(node.expression);
    if (!contextualType)
        return;
    for (const property of type.getProperties()) {
        const basePropertyType = state.typeChecker.getTypeOfPropertyOfType(type, property.name);
        const assignmentPropertyType = state.typeChecker.getTypeOfPropertyOfType(contextualType, property.name);
        if (!basePropertyType)
            continue;
        if (!assignmentPropertyType)
            continue;
        validateTypes(state, node, basePropertyType, assignmentPropertyType);
    }
}
function validateMethodAssignment(state, node) {
    if (typescript_1.default.isClassElement(node) && typescript_1.default.isClassLike(node.parent) && node.name) {
        for (const typeNode of typescript_1.default.getAllSuperTypeNodes(node.parent)) {
            validateHeritageClause(state, node, typeNode);
        }
    }
    else if (typescript_1.default.isObjectLiteralElementLike(node)) {
        if (typescript_1.default.isSpreadAssignment(node)) {
            if (!typescript_1.default.isObjectLiteralExpression(node.expression)) {
                validateSpread(state, node);
            }
        }
        else {
            validateObjectLiteralElement(state, node);
        }
    }
}
exports.validateMethodAssignment = validateMethodAssignment;
//# sourceMappingURL=validateMethodAssignment.js.map