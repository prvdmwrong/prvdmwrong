"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getExtendsNode = void 0;
const typescript_1 = __importDefault(require("typescript"));
function getExtendsNode(node) {
    var _a;
    for (const clause of (_a = node.heritageClauses) !== null && _a !== void 0 ? _a : []) {
        if (clause.token === typescript_1.default.SyntaxKind.ExtendsKeyword) {
            return clause.types[0];
        }
    }
}
exports.getExtendsNode = getExtendsNode;
//# sourceMappingURL=getExtendsNode.js.map