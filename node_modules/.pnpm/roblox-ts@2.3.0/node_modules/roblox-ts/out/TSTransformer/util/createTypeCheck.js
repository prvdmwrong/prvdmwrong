"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createTypeCheck = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
function createTypeCheck(expression, typeName) {
    return luau_ast_1.default.binary(luau_ast_1.default.call(luau_ast_1.default.globals.type, [expression]), "==", typeName);
}
exports.createTypeCheck = createTypeCheck;
//# sourceMappingURL=createTypeCheck.js.map