"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createGetService = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
function createGetService(serviceName) {
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.MethodCallExpression, {
        expression: luau_ast_1.default.globals.game,
        name: "GetService",
        args: luau_ast_1.default.list.make(luau_ast_1.default.string(serviceName)),
    });
}
exports.createGetService = createGetService;
//# sourceMappingURL=createGetService.js.map