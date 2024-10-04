"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformBindingName = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformArrayBindingPattern_1 = require("./transformArrayBindingPattern");
const transformObjectBindingPattern_1 = require("./transformObjectBindingPattern");
const transformIdentifier_1 = require("../expressions/transformIdentifier");
const typescript_1 = __importDefault(require("typescript"));
function transformBindingName(state, name, initializers) {
    let id;
    if (typescript_1.default.isIdentifier(name)) {
        id = (0, transformIdentifier_1.transformIdentifierDefined)(state, name);
    }
    else {
        id = luau_ast_1.default.tempId("binding");
        luau_ast_1.default.list.pushList(initializers, state.capturePrereqs(() => {
            if (typescript_1.default.isArrayBindingPattern(name)) {
                (0, transformArrayBindingPattern_1.transformArrayBindingPattern)(state, name, id);
            }
            else {
                (0, transformObjectBindingPattern_1.transformObjectBindingPattern)(state, name, id);
            }
        }));
    }
    return id;
}
exports.transformBindingName = transformBindingName;
//# sourceMappingURL=transformBindingName.js.map