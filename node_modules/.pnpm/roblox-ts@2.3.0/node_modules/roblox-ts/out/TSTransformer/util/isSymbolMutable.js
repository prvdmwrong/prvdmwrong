"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isSymbolMutable = void 0;
const getOrSetDefault_1 = require("../../Shared/util/getOrSetDefault");
const traversal_1 = require("./traversal");
const typescript_1 = __importDefault(require("typescript"));
function isSymbolMutable(state, idSymbol) {
    return (0, getOrSetDefault_1.getOrSetDefault)(state.multiTransformState.isDefinedAsLetCache, idSymbol, () => {
        if (idSymbol.valueDeclaration) {
            if (typescript_1.default.isParameter(idSymbol.valueDeclaration)) {
                return true;
            }
            const varDecList = (0, traversal_1.getAncestor)(idSymbol.valueDeclaration, typescript_1.default.isVariableDeclarationList);
            if (varDecList) {
                return !!(varDecList.flags & typescript_1.default.NodeFlags.Let);
            }
        }
        return false;
    });
}
exports.isSymbolMutable = isSymbolMutable;
//# sourceMappingURL=isSymbolMutable.js.map