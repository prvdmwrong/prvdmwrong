"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getAssignableValue = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const types_1 = require("./types");
function getAssignableValue(operator, value, valueType) {
    if (operator === "..=" && !(0, types_1.isDefinitelyType)(valueType, types_1.isStringType)) {
        return luau_ast_1.default.call(luau_ast_1.default.globals.tostring, [value]);
    }
    return value;
}
exports.getAssignableValue = getAssignableValue;
//# sourceMappingURL=getAssignableValue.js.map