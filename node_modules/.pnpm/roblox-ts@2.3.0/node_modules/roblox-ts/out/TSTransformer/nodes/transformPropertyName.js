"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformPropertyName = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("./expressions/transformExpression");
const typescript_1 = __importDefault(require("typescript"));
function transformPropertyName(state, name) {
    if (typescript_1.default.isIdentifier(name)) {
        return luau_ast_1.default.string(name.text);
    }
    else {
        return (0, transformExpression_1.transformExpression)(state, typescript_1.default.isComputedPropertyName(name) ? name.expression : name);
    }
}
exports.transformPropertyName = transformPropertyName;
//# sourceMappingURL=transformPropertyName.js.map