"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isNamespace = exports.isTemplateLiteralType = exports.isUnaryAssignmentOperator = exports.isBlockLike = void 0;
const typescript_1 = __importDefault(require("typescript"));
function isBlockLike(node) {
    return (node.kind === typescript_1.default.SyntaxKind.SourceFile ||
        node.kind === typescript_1.default.SyntaxKind.Block ||
        node.kind === typescript_1.default.SyntaxKind.ModuleBlock ||
        node.kind === typescript_1.default.SyntaxKind.CaseClause ||
        node.kind === typescript_1.default.SyntaxKind.DefaultClause);
}
exports.isBlockLike = isBlockLike;
function isUnaryAssignmentOperator(operator) {
    return operator === typescript_1.default.SyntaxKind.PlusPlusToken || operator === typescript_1.default.SyntaxKind.MinusMinusToken;
}
exports.isUnaryAssignmentOperator = isUnaryAssignmentOperator;
function isTemplateLiteralType(type) {
    return "texts" in type && "types" in type && !!(type.flags & typescript_1.default.TypeFlags.TemplateLiteral);
}
exports.isTemplateLiteralType = isTemplateLiteralType;
function isNamespace(node) {
    return typescript_1.default.isModuleDeclaration(node) && !!(node.flags & typescript_1.default.NodeFlags.Namespace);
}
exports.isNamespace = isNamespace;
//# sourceMappingURL=typeGuards.js.map