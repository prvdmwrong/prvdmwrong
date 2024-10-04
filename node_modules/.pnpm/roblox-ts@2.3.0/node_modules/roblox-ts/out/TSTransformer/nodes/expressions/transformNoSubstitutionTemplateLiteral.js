"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformNoSubstitutionTemplateLiteral = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformInterpolatedStringPart_1 = require("../transformInterpolatedStringPart");
function transformNoSubstitutionTemplateLiteral(state, node) {
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.InterpolatedString, {
        parts: luau_ast_1.default.list.make((0, transformInterpolatedStringPart_1.transformInterpolatedStringPart)(node)),
    });
}
exports.transformNoSubstitutionTemplateLiteral = transformNoSubstitutionTemplateLiteral;
//# sourceMappingURL=transformNoSubstitutionTemplateLiteral.js.map