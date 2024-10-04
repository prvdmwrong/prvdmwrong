"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CALL_MACROS = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../Shared/diagnostics");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const convertToIndexableExpression_1 = require("../util/convertToIndexableExpression");
const createImportExpression_1 = require("../util/createImportExpression");
const createTruthinessChecks_1 = require("../util/createTruthinessChecks");
const PRIMITIVE_LUAU_TYPES = new Set([
    "nil",
    "boolean",
    "string",
    "number",
    "table",
    "userdata",
    "function",
    "thread",
    "vector",
    "buffer",
]);
exports.CALL_MACROS = {
    assert: (state, node, expression, args) => {
        args[0] = (0, createTruthinessChecks_1.createTruthinessChecks)(state, args[0], node.arguments[0]);
        return luau_ast_1.default.call(luau_ast_1.default.globals.assert, args);
    },
    typeOf: (state, node, expression, args) => luau_ast_1.default.call(luau_ast_1.default.globals.typeof, args),
    typeIs: (state, node, expression, args) => {
        const [value, typeStr] = args;
        const typeFunc = luau_ast_1.default.isStringLiteral(typeStr) && PRIMITIVE_LUAU_TYPES.has(typeStr.value)
            ? luau_ast_1.default.globals.type
            : luau_ast_1.default.globals.typeof;
        return luau_ast_1.default.binary(luau_ast_1.default.call(typeFunc, [value]), "==", typeStr);
    },
    classIs: (state, node, expression, args) => {
        const [value, typeStr] = args;
        return luau_ast_1.default.binary(luau_ast_1.default.property((0, convertToIndexableExpression_1.convertToIndexableExpression)(value), "ClassName"), "==", typeStr);
    },
    identity: (state, node, expression, args) => args[0],
    $range: (state, node) => {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noRangeMacroOutsideForOf(node.expression));
        return luau_ast_1.default.none();
    },
    $tuple: (state, node) => {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noTupleMacroOutsideReturn(node));
        return luau_ast_1.default.none();
    },
    $getModuleTree: (state, node) => {
        const parts = (0, createImportExpression_1.getImportParts)(state, node.getSourceFile(), node.arguments[0]);
        return luau_ast_1.default.array([parts.shift(), luau_ast_1.default.array(parts)]);
    },
};
//# sourceMappingURL=callMacros.js.map