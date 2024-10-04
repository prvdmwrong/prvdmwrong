"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isFinalStatement = exports.isTable = exports.isSimplePrimitive = exports.isSimple = exports.isNode = exports.isField = exports.isInterpolatedStringPart = exports.isMapField = exports.isStatement = exports.isComment = exports.isReturnStatement = exports.isVariableDeclaration = exports.isMethodDeclaration = exports.isFunctionDeclaration = exports.isForStatement = exports.isNumericForStatement = exports.isIfStatement = exports.isRepeatStatement = exports.isWhileStatement = exports.isDoStatement = exports.isContinueStatement = exports.isCallStatement = exports.isBreakStatement = exports.isAssignment = exports.isExpression = exports.isMixedTable = exports.isSet = exports.isMap = exports.isArray = exports.isInterpolatedString = exports.isIfExpression = exports.isUnaryExpression = exports.isBinaryExpression = exports.isFunctionExpression = exports.isVarArgsLiteral = exports.isStringLiteral = exports.isNumberLiteral = exports.isTrueLiteral = exports.isFalseLiteral = exports.isNilLiteral = exports.isNone = exports.isIndexableExpression = exports.isParenthesizedExpression = exports.isMethodCallExpression = exports.isCallExpression = exports.isPropertyAccessExpression = exports.isComputedIndexExpression = exports.isTemporaryIdentifier = exports.isIdentifier = exports.isAnyIdentifier = void 0;
exports.isExpressionWithPrecedence = exports.hasStatements = exports.isFunctionLike = exports.isWritableExpression = exports.isCall = void 0;
const luau = __importStar(require("../bundle"));
function makeGuard(...kinds) {
    const set = new Set(kinds);
    return (node) => set.has(node.kind);
}
exports.isAnyIdentifier = makeGuard(luau.SyntaxKind.Identifier, luau.SyntaxKind.TemporaryIdentifier);
exports.isIdentifier = makeGuard(luau.SyntaxKind.Identifier);
exports.isTemporaryIdentifier = makeGuard(luau.SyntaxKind.TemporaryIdentifier);
exports.isComputedIndexExpression = makeGuard(luau.SyntaxKind.ComputedIndexExpression);
exports.isPropertyAccessExpression = makeGuard(luau.SyntaxKind.PropertyAccessExpression);
exports.isCallExpression = makeGuard(luau.SyntaxKind.CallExpression);
exports.isMethodCallExpression = makeGuard(luau.SyntaxKind.MethodCallExpression);
exports.isParenthesizedExpression = makeGuard(luau.SyntaxKind.ParenthesizedExpression);
function isIndexableExpression(node) {
    return (node.kind >= luau.SyntaxKind.FirstIndexableExpression && node.kind <= luau.SyntaxKind.LastIndexableExpression);
}
exports.isIndexableExpression = isIndexableExpression;
exports.isNone = makeGuard(luau.SyntaxKind.None);
exports.isNilLiteral = makeGuard(luau.SyntaxKind.NilLiteral);
exports.isFalseLiteral = makeGuard(luau.SyntaxKind.FalseLiteral);
exports.isTrueLiteral = makeGuard(luau.SyntaxKind.TrueLiteral);
exports.isNumberLiteral = makeGuard(luau.SyntaxKind.NumberLiteral);
exports.isStringLiteral = makeGuard(luau.SyntaxKind.StringLiteral);
exports.isVarArgsLiteral = makeGuard(luau.SyntaxKind.VarArgsLiteral);
exports.isFunctionExpression = makeGuard(luau.SyntaxKind.FunctionExpression);
exports.isBinaryExpression = makeGuard(luau.SyntaxKind.BinaryExpression);
exports.isUnaryExpression = makeGuard(luau.SyntaxKind.UnaryExpression);
exports.isIfExpression = makeGuard(luau.SyntaxKind.IfExpression);
exports.isInterpolatedString = makeGuard(luau.SyntaxKind.InterpolatedString);
exports.isArray = makeGuard(luau.SyntaxKind.Array);
exports.isMap = makeGuard(luau.SyntaxKind.Map);
exports.isSet = makeGuard(luau.SyntaxKind.Set);
exports.isMixedTable = makeGuard(luau.SyntaxKind.MixedTable);
function isExpression(node) {
    return node.kind >= luau.SyntaxKind.FirstExpression && node.kind <= luau.SyntaxKind.LastExpression;
}
exports.isExpression = isExpression;
exports.isAssignment = makeGuard(luau.SyntaxKind.Assignment);
exports.isBreakStatement = makeGuard(luau.SyntaxKind.BreakStatement);
exports.isCallStatement = makeGuard(luau.SyntaxKind.CallStatement);
exports.isContinueStatement = makeGuard(luau.SyntaxKind.ContinueStatement);
exports.isDoStatement = makeGuard(luau.SyntaxKind.DoStatement);
exports.isWhileStatement = makeGuard(luau.SyntaxKind.WhileStatement);
exports.isRepeatStatement = makeGuard(luau.SyntaxKind.RepeatStatement);
exports.isIfStatement = makeGuard(luau.SyntaxKind.IfStatement);
exports.isNumericForStatement = makeGuard(luau.SyntaxKind.NumericForStatement);
exports.isForStatement = makeGuard(luau.SyntaxKind.ForStatement);
exports.isFunctionDeclaration = makeGuard(luau.SyntaxKind.FunctionDeclaration);
exports.isMethodDeclaration = makeGuard(luau.SyntaxKind.MethodDeclaration);
exports.isVariableDeclaration = makeGuard(luau.SyntaxKind.VariableDeclaration);
exports.isReturnStatement = makeGuard(luau.SyntaxKind.ReturnStatement);
exports.isComment = makeGuard(luau.SyntaxKind.Comment);
function isStatement(node) {
    return node.kind >= luau.SyntaxKind.FirstStatement && node.kind <= luau.SyntaxKind.LastStatement;
}
exports.isStatement = isStatement;
exports.isMapField = makeGuard(luau.SyntaxKind.MapField);
exports.isInterpolatedStringPart = makeGuard(luau.SyntaxKind.InterpolatedStringPart);
function isField(node) {
    return node.kind >= luau.SyntaxKind.FirstField && node.kind <= luau.SyntaxKind.LastField;
}
exports.isField = isField;
function isNode(value) {
    if (typeof value === "object" && value !== null && "kind" in value) {
        const { kind } = value;
        return (typeof kind === "number" &&
            kind >= luau.SyntaxKind.FirstIndexableExpression &&
            kind <= luau.SyntaxKind.LastField);
    }
    return false;
}
exports.isNode = isNode;
exports.isSimple = makeGuard(luau.SyntaxKind.Identifier, luau.SyntaxKind.TemporaryIdentifier, luau.SyntaxKind.NilLiteral, luau.SyntaxKind.TrueLiteral, luau.SyntaxKind.FalseLiteral, luau.SyntaxKind.NumberLiteral, luau.SyntaxKind.StringLiteral);
exports.isSimplePrimitive = makeGuard(luau.SyntaxKind.NilLiteral, luau.SyntaxKind.TrueLiteral, luau.SyntaxKind.FalseLiteral, luau.SyntaxKind.NumberLiteral, luau.SyntaxKind.StringLiteral);
exports.isTable = makeGuard(luau.SyntaxKind.Array, luau.SyntaxKind.Set, luau.SyntaxKind.Map, luau.SyntaxKind.MixedTable);
exports.isFinalStatement = makeGuard(luau.SyntaxKind.BreakStatement, luau.SyntaxKind.ReturnStatement, luau.SyntaxKind.ContinueStatement);
exports.isCall = makeGuard(luau.SyntaxKind.CallExpression, luau.SyntaxKind.MethodCallExpression);
exports.isWritableExpression = makeGuard(luau.SyntaxKind.Identifier, luau.SyntaxKind.TemporaryIdentifier, luau.SyntaxKind.PropertyAccessExpression, luau.SyntaxKind.ComputedIndexExpression);
exports.isFunctionLike = makeGuard(luau.SyntaxKind.FunctionDeclaration, luau.SyntaxKind.FunctionExpression, luau.SyntaxKind.MethodDeclaration);
exports.hasStatements = makeGuard(luau.SyntaxKind.ForStatement, luau.SyntaxKind.NumericForStatement, luau.SyntaxKind.FunctionExpression, luau.SyntaxKind.DoStatement, luau.SyntaxKind.FunctionDeclaration, luau.SyntaxKind.IfStatement, luau.SyntaxKind.MethodDeclaration, luau.SyntaxKind.RepeatStatement, luau.SyntaxKind.WhileStatement);
exports.isExpressionWithPrecedence = makeGuard(luau.SyntaxKind.IfExpression, luau.SyntaxKind.UnaryExpression, luau.SyntaxKind.BinaryExpression);
//# sourceMappingURL=typeGuards.js.map