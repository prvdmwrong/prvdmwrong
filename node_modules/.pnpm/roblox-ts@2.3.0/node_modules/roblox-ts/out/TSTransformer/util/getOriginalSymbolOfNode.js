"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getOriginalSymbolOfNode = void 0;
const typescript_1 = __importDefault(require("typescript"));
function getOriginalSymbolOfNode(typeChecker, node) {
    const symbol = typeChecker.getSymbolAtLocation(node);
    if (symbol) {
        return typescript_1.default.skipAlias(symbol, typeChecker);
    }
    return symbol;
}
exports.getOriginalSymbolOfNode = getOriginalSymbolOfNode;
//# sourceMappingURL=getOriginalSymbolOfNode.js.map