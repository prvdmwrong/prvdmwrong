"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isMethod = exports.isMethodFromType = void 0;
const diagnostics_1 = require("../../Shared/diagnostics");
const getOrSetDefault_1 = require("../../Shared/util/getOrSetDefault");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const traversal_1 = require("./traversal");
const types_1 = require("./types");
const typescript_1 = __importDefault(require("typescript"));
function getThisParameter(parameters) {
    const firstParam = parameters[0];
    if (firstParam) {
        const name = firstParam.name;
        if (typescript_1.default.isIdentifier(name) && typescript_1.default.isThisIdentifier(name)) {
            return name;
        }
    }
}
function isMethodDeclaration(state, node) {
    if (typescript_1.default.isFunctionLike(node)) {
        const thisParam = getThisParameter(node.parameters);
        if (thisParam) {
            return !(state.getType(thisParam).flags & typescript_1.default.TypeFlags.Void);
        }
        else {
            if (typescript_1.default.isFunctionDeclaration(node)) {
                return false;
            }
            if (typescript_1.default.isMethodDeclaration(node) || typescript_1.default.isMethodSignature(node)) {
                return true;
            }
            if (typescript_1.default.isFunctionExpression(node)) {
                const parent = (0, traversal_1.skipUpwards)(node).parent;
                if (typescript_1.default.isPropertyAssignment(parent)) {
                    const grandparent = (0, traversal_1.skipUpwards)(parent).parent;
                    if (typescript_1.default.isObjectLiteralExpression(grandparent)) {
                        return true;
                    }
                }
            }
            return false;
        }
    }
    return false;
}
function isMethodInner(state, node, type) {
    var _a;
    let hasMethodDefinition = false;
    let hasCallbackDefinition = false;
    for (const callSignature of type.getCallSignatures()) {
        const thisValueDeclaration = (_a = callSignature.thisParameter) === null || _a === void 0 ? void 0 : _a.valueDeclaration;
        if (thisValueDeclaration) {
            if (!(state.getType(thisValueDeclaration).flags & typescript_1.default.TypeFlags.Void)) {
                hasMethodDefinition = true;
            }
            else {
                hasCallbackDefinition = true;
            }
        }
        else if (callSignature.declaration) {
            if (isMethodDeclaration(state, callSignature.declaration)) {
                hasMethodDefinition = true;
            }
            else {
                hasCallbackDefinition = true;
            }
        }
    }
    if (hasMethodDefinition && hasCallbackDefinition) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noMixedTypeCall(node));
    }
    return hasMethodDefinition;
}
function isMethodFromType(state, node, type) {
    let result = false;
    (0, types_1.walkTypes)(type, t => {
        if (t.symbol) {
            result || (result = (0, getOrSetDefault_1.getOrSetDefault)(state.multiTransformState.isMethodCache, t.symbol, () => isMethodInner(state, node, t)));
        }
    });
    return result;
}
exports.isMethodFromType = isMethodFromType;
function isMethod(state, node) {
    return isMethodFromType(state, node, state.getType(node));
}
exports.isMethod = isMethod;
//# sourceMappingURL=isMethod.js.map