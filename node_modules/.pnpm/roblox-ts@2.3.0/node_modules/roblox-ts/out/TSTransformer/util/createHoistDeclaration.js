"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createHoistDeclaration = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformIdentifier_1 = require("../nodes/expressions/transformIdentifier");
const validateIdentifier_1 = require("./validateIdentifier");
function createHoistDeclaration(state, statement) {
    const hoists = state.hoistsByStatement.get(statement);
    if (hoists && hoists.length > 0) {
        hoists.forEach(hoist => (0, validateIdentifier_1.validateIdentifier)(state, hoist));
        return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: luau_ast_1.default.list.make(...hoists.map(hoistId => (0, transformIdentifier_1.transformIdentifierDefined)(state, hoistId))),
            right: undefined,
        });
    }
}
exports.createHoistDeclaration = createHoistDeclaration;
//# sourceMappingURL=createHoistDeclaration.js.map