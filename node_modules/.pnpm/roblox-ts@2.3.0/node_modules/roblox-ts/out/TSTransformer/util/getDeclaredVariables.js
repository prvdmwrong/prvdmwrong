"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getDeclaredVariables = void 0;
const typescript_1 = __importDefault(require("typescript"));
function getDeclaredVariablesFromBindingName(node, list) {
    if (typescript_1.default.isIdentifier(node)) {
        list.push(node);
    }
    else if (typescript_1.default.isObjectBindingPattern(node)) {
        for (const element of node.elements) {
            getDeclaredVariablesFromBindingName(element.name, list);
        }
    }
    else if (typescript_1.default.isArrayBindingPattern(node)) {
        for (const element of node.elements) {
            if (!typescript_1.default.isOmittedExpression(element)) {
                getDeclaredVariablesFromBindingName(element.name, list);
            }
        }
    }
}
function getDeclaredVariables(node) {
    const list = new Array();
    if (typescript_1.default.isVariableDeclarationList(node)) {
        for (const declaration of node.declarations) {
            getDeclaredVariablesFromBindingName(declaration.name, list);
        }
    }
    else {
        getDeclaredVariablesFromBindingName(node.name, list);
    }
    return list;
}
exports.getDeclaredVariables = getDeclaredVariables;
//# sourceMappingURL=getDeclaredVariables.js.map