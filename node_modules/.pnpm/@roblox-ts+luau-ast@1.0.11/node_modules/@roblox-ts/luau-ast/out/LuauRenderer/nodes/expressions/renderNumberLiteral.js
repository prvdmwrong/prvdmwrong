"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderNumberLiteral = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
function renderNumberLiteral(state, node) {
    return LuauAST_1.default.isValidNumberLiteral(node.value) ? node.value : String(Number(node.value.replace(/_/g, "")));
}
exports.renderNumberLiteral = renderNumberLiteral;
//# sourceMappingURL=renderNumberLiteral.js.map