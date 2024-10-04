"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.renderInterpolatedString = void 0;
const LuauAST_1 = __importDefault(require("../../../LuauAST"));
const LuauRenderer_1 = require("../..");
function renderInterpolatedString(state, node) {
    let result = "`";
    LuauAST_1.default.list.forEach(node.parts, part => {
        let expressionStr = (0, LuauRenderer_1.render)(state, part);
        if (LuauAST_1.default.isInterpolatedStringPart(part)) {
            result += expressionStr;
        }
        else {
            result += "{";
            if (LuauAST_1.default.isTable(part)) {
                expressionStr = `(${expressionStr})`;
            }
            result += expressionStr;
            result += "}";
        }
    });
    result += "`";
    return result;
}
exports.renderInterpolatedString = renderInterpolatedString;
//# sourceMappingURL=renderInterpolatedString.js.map