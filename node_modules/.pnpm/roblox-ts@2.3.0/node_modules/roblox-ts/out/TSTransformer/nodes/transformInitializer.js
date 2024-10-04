"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformInitializer = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("./expressions/transformExpression");
function transformInitializer(state, id, initializer) {
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
        condition: luau_ast_1.default.binary(id, "==", luau_ast_1.default.nil()),
        elseBody: luau_ast_1.default.list.make(),
        statements: state.capturePrereqs(() => {
            state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: id,
                operator: "=",
                right: (0, transformExpression_1.transformExpression)(state, initializer),
            }));
        }),
    });
}
exports.transformInitializer = transformInitializer;
//# sourceMappingURL=transformInitializer.js.map