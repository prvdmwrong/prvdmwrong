"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getKindName = void 0;
const LuauAST_1 = __importDefault(require(".."));
function getKindName(kind) {
    if (kind === LuauAST_1.default.SyntaxKind.Identifier)
        return "Identifier";
    else if (kind === LuauAST_1.default.SyntaxKind.ParenthesizedExpression)
        return "ParenthesizedExpression";
    else if (kind === LuauAST_1.default.SyntaxKind.Set)
        return "Set";
    else if (kind === LuauAST_1.default.SyntaxKind.Assignment)
        return "Assignment";
    else if (kind === LuauAST_1.default.SyntaxKind.Comment)
        return "Comment";
    else if (kind === LuauAST_1.default.SyntaxKind.MapField)
        return "MapField";
    return LuauAST_1.default.SyntaxKind[kind];
}
exports.getKindName = getKindName;
//# sourceMappingURL=getKindName.js.map