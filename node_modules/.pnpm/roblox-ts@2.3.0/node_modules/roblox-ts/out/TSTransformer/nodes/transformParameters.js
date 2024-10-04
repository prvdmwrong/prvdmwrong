"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformParameters = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../Shared/diagnostics");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const transformArrayBindingPattern_1 = require("./binding/transformArrayBindingPattern");
const transformObjectBindingPattern_1 = require("./binding/transformObjectBindingPattern");
const transformIdentifier_1 = require("./expressions/transformIdentifier");
const transformInitializer_1 = require("./transformInitializer");
const isMethod_1 = require("../util/isMethod");
const validateIdentifier_1 = require("../util/validateIdentifier");
const typescript_1 = __importDefault(require("typescript"));
function optimizeArraySpreadParameter(state, parameters, bindingPattern) {
    for (const element of bindingPattern.elements) {
        if (typescript_1.default.isOmittedExpression(element)) {
            luau_ast_1.default.list.push(parameters, luau_ast_1.default.tempId());
        }
        else {
            if (element.dotDotDotToken) {
                DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noSpreadDestructuring(element));
                return;
            }
            const name = element.name;
            if (typescript_1.default.isIdentifier(name)) {
                const paramId = (0, transformIdentifier_1.transformIdentifierDefined)(state, name);
                (0, validateIdentifier_1.validateIdentifier)(state, name);
                luau_ast_1.default.list.push(parameters, paramId);
                if (element.initializer) {
                    state.prereq((0, transformInitializer_1.transformInitializer)(state, paramId, element.initializer));
                }
            }
            else {
                const paramId = luau_ast_1.default.tempId("param");
                luau_ast_1.default.list.push(parameters, paramId);
                if (element.initializer) {
                    state.prereq((0, transformInitializer_1.transformInitializer)(state, paramId, element.initializer));
                }
                if (typescript_1.default.isArrayBindingPattern(name)) {
                    (0, transformArrayBindingPattern_1.transformArrayBindingPattern)(state, name, paramId);
                }
                else {
                    (0, transformObjectBindingPattern_1.transformObjectBindingPattern)(state, name, paramId);
                }
            }
        }
    }
}
function transformParameters(state, node) {
    const parameters = luau_ast_1.default.list.make();
    const statements = luau_ast_1.default.list.make();
    let hasDotDotDot = false;
    if ((0, isMethod_1.isMethod)(state, node)) {
        luau_ast_1.default.list.push(parameters, luau_ast_1.default.globals.self);
    }
    for (const parameter of node.parameters) {
        if (typescript_1.default.isThisIdentifier(parameter.name)) {
            continue;
        }
        if (parameter.dotDotDotToken && typescript_1.default.isArrayBindingPattern(parameter.name)) {
            const prereqs = state.capturePrereqs(() => optimizeArraySpreadParameter(state, parameters, parameter.name));
            luau_ast_1.default.list.pushList(statements, prereqs);
            continue;
        }
        let paramId;
        if (typescript_1.default.isIdentifier(parameter.name)) {
            paramId = (0, transformIdentifier_1.transformIdentifierDefined)(state, parameter.name);
            (0, validateIdentifier_1.validateIdentifier)(state, parameter.name);
        }
        else {
            paramId = luau_ast_1.default.tempId("param");
        }
        if (parameter.dotDotDotToken) {
            hasDotDotDot = true;
            luau_ast_1.default.list.push(statements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
                left: paramId,
                right: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Array, {
                    members: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VarArgsLiteral, {})),
                }),
            }));
        }
        else {
            luau_ast_1.default.list.push(parameters, paramId);
        }
        if (parameter.initializer) {
            luau_ast_1.default.list.push(statements, (0, transformInitializer_1.transformInitializer)(state, paramId, parameter.initializer));
        }
        if (!typescript_1.default.isIdentifier(parameter.name)) {
            const bindingPattern = parameter.name;
            if (typescript_1.default.isArrayBindingPattern(bindingPattern)) {
                luau_ast_1.default.list.pushList(statements, state.capturePrereqs(() => (0, transformArrayBindingPattern_1.transformArrayBindingPattern)(state, bindingPattern, paramId)));
            }
            else {
                luau_ast_1.default.list.pushList(statements, state.capturePrereqs(() => (0, transformObjectBindingPattern_1.transformObjectBindingPattern)(state, bindingPattern, paramId)));
            }
        }
    }
    return {
        parameters,
        statements,
        hasDotDotDot,
    };
}
exports.transformParameters = transformParameters;
//# sourceMappingURL=transformParameters.js.map