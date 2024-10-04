"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderIdentifier = void 0;
const LuauAST_1 = __importDefault(require("../../../../LuauAST"));
const assert_1 = require("../../../../LuauAST/util/assert");
function renderIdentifier(state, node) {
    (0, assert_1.assert)(LuauAST_1.default.isValidIdentifier(node.name), `Invalid Luau Identifier: "${node.name}"`);
    return node.name;
}
exports.renderIdentifier = renderIdentifier;
//# sourceMappingURL=renderIdentifier.js.map