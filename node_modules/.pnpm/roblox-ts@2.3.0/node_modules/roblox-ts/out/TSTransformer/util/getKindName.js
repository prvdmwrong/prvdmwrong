"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getKindName = void 0;
const typescript_1 = __importDefault(require("typescript"));
function getKindName(kind) {
    if (kind === typescript_1.default.SyntaxKind.FirstAssignment)
        return "EqualsToken";
    if (kind === typescript_1.default.SyntaxKind.FirstCompoundAssignment)
        return "PlusEqualsToken";
    if (kind === typescript_1.default.SyntaxKind.LastReservedWord)
        return "WithKeyword";
    if (kind === typescript_1.default.SyntaxKind.FirstKeyword)
        return "BreakKeyword";
    if (kind === typescript_1.default.SyntaxKind.FirstFutureReservedWord)
        return "ImplementsKeyword";
    if (kind === typescript_1.default.SyntaxKind.LastFutureReservedWord)
        return "YieldKeyword";
    if (kind === typescript_1.default.SyntaxKind.FirstTypeNode)
        return "TypePredicate";
    if (kind === typescript_1.default.SyntaxKind.LastTypeNode)
        return "ImportType";
    if (kind === typescript_1.default.SyntaxKind.FirstPunctuation)
        return "OpenBraceToken";
    if (kind === typescript_1.default.SyntaxKind.FirstToken)
        return "Unknown";
    if (kind === typescript_1.default.SyntaxKind.FirstTriviaToken)
        return "SingleLineCommentTrivia";
    if (kind === typescript_1.default.SyntaxKind.LastTriviaToken)
        return "ConflictMarkerTrivia";
    if (kind === typescript_1.default.SyntaxKind.FirstLiteralToken)
        return "NumericLiteral";
    if (kind === typescript_1.default.SyntaxKind.FirstTemplateToken)
        return "NoSubstitutionTemplateLiteral";
    if (kind === typescript_1.default.SyntaxKind.LastTemplateToken)
        return "TemplateTail";
    if (kind === typescript_1.default.SyntaxKind.FirstBinaryOperator)
        return "LessThanToken";
    if (kind === typescript_1.default.SyntaxKind.LastBinaryOperator)
        return "CaretEqualsToken";
    if (kind === typescript_1.default.SyntaxKind.FirstStatement)
        return "VariableStatement";
    if (kind === typescript_1.default.SyntaxKind.LastStatement)
        return "DebuggerStatement";
    if (kind === typescript_1.default.SyntaxKind.FirstNode)
        return "QualifiedName";
    if (kind === typescript_1.default.SyntaxKind.FirstJSDocNode)
        return "JSDocTypeExpression";
    if (kind === typescript_1.default.SyntaxKind.FirstJSDocTagNode)
        return "JSDocTag";
    if (kind === typescript_1.default.SyntaxKind.LastJSDocTagNode)
        return "JSDocPropertyTag";
    if (kind === typescript_1.default.SyntaxKind.FirstContextualKeyword)
        return "AbstractKeyword";
    if (kind === typescript_1.default.SyntaxKind.LastContextualKeyword)
        return "OfKeyword";
    return typescript_1.default.SyntaxKind[kind];
}
exports.getKindName = getKindName;
//# sourceMappingURL=getKindName.js.map