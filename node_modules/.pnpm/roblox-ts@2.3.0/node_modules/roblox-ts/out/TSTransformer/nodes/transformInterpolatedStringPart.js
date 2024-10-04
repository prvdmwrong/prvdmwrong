"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformInterpolatedStringPart = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const createStringFromLiteral_1 = require("../util/createStringFromLiteral");
function transformInterpolatedStringPart(node) {
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.InterpolatedStringPart, { text: (0, createStringFromLiteral_1.createStringFromLiteral)(node) });
}
exports.transformInterpolatedStringPart = transformInterpolatedStringPart;
//# sourceMappingURL=transformInterpolatedStringPart.js.map