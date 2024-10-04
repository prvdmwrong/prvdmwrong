"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderTemporaryIdentifier = void 0;
const LuauAST_1 = __importDefault(require("../../../../LuauAST"));
const assert_1 = require("../../../../LuauAST/util/assert");
function renderTemporaryIdentifier(state, node) {
    const name = state.getTempName(node);
    (0, assert_1.assert)(LuauAST_1.default.isValidIdentifier(name), `Invalid Temporary Identifier: "${name}"`);
    return name;
}
exports.renderTemporaryIdentifier = renderTemporaryIdentifier;
//# sourceMappingURL=renderTemporaryIdentifier.js.map