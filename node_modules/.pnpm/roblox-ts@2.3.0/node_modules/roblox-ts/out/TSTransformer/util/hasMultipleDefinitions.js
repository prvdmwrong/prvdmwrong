"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.hasMultipleDefinitions = void 0;
function hasMultipleDefinitions(symbol, filter) {
    var _a;
    let amtValueDefinitions = 0;
    for (const declaration of (_a = symbol.getDeclarations()) !== null && _a !== void 0 ? _a : []) {
        if (filter(declaration)) {
            amtValueDefinitions++;
            if (amtValueDefinitions > 1) {
                return true;
            }
        }
    }
    return false;
}
exports.hasMultipleDefinitions = hasMultipleDefinitions;
//# sourceMappingURL=hasMultipleDefinitions.js.map