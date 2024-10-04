"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformMethodDeclaration = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../Shared/diagnostics");
const assert_1 = require("../../Shared/util/assert");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const transformParameters_1 = require("./transformParameters");
const transformPropertyName_1 = require("./transformPropertyName");
const transformStatementList_1 = require("./transformStatementList");
const isMethod_1 = require("../util/isMethod");
const pointer_1 = require("../util/pointer");
const wrapStatementsAsGenerator_1 = require("../util/wrapStatementsAsGenerator");
const typescript_1 = __importDefault(require("typescript"));
function transformMethodDeclaration(state, node, ptr) {
    const result = luau_ast_1.default.list.make();
    if (!node.body) {
        return luau_ast_1.default.list.make();
    }
    (0, assert_1.assert)(node.name);
    if (typescript_1.default.isPrivateIdentifier(node.name)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noPrivateIdentifier(node.name));
        return luau_ast_1.default.list.make();
    }
    let { statements, parameters, hasDotDotDot } = (0, transformParameters_1.transformParameters)(state, node);
    luau_ast_1.default.list.pushList(statements, (0, transformStatementList_1.transformStatementList)(state, node.body, node.body.statements));
    let name = (0, transformPropertyName_1.transformPropertyName)(state, node.name);
    if (typescript_1.default.hasDecorators(node) && !luau_ast_1.default.isSimple(name)) {
        const tempId = luau_ast_1.default.tempId("key");
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: tempId,
            right: name,
        }));
        name = tempId;
        state.setClassElementObjectKey(node, tempId);
    }
    const isAsync = !!typescript_1.default.getSelectedSyntacticModifierFlags(node, typescript_1.default.ModifierFlags.Async);
    if (node.asteriskToken) {
        if (isAsync) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noAsyncGeneratorFunctions(node));
        }
        statements = (0, wrapStatementsAsGenerator_1.wrapStatementsAsGenerator)(state, node, statements);
    }
    if (!isAsync && luau_ast_1.default.isStringLiteral(name) && !luau_ast_1.default.isMap(ptr.value) && luau_ast_1.default.isValidIdentifier(name.value)) {
        if ((0, isMethod_1.isMethod)(state, node)) {
            luau_ast_1.default.list.shift(parameters);
            luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.MethodDeclaration, {
                expression: ptr.value,
                name: name.value,
                statements,
                parameters,
                hasDotDotDot,
            }));
        }
        else {
            luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.FunctionDeclaration, {
                name: luau_ast_1.default.property(ptr.value, name.value),
                localize: false,
                statements,
                parameters,
                hasDotDotDot,
            }));
        }
        return result;
    }
    let expression = luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.FunctionExpression, {
        statements,
        parameters,
        hasDotDotDot,
    });
    if (isAsync) {
        expression = luau_ast_1.default.call(state.TS(node, "async"), [expression]);
    }
    luau_ast_1.default.list.pushList(result, state.capturePrereqs(() => (0, pointer_1.assignToMapPointer)(state, ptr, name, expression)));
    return result;
}
exports.transformMethodDeclaration = transformMethodDeclaration;
//# sourceMappingURL=transformMethodDeclaration.js.map