"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformBlock = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformStatementList_1 = require("../transformStatementList");
function transformBlock(state, node) {
    return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.DoStatement, {
        statements: (0, transformStatementList_1.transformStatementList)(state, node, node.statements),
    }));
}
exports.transformBlock = transformBlock;
//# sourceMappingURL=transformBlock.js.map