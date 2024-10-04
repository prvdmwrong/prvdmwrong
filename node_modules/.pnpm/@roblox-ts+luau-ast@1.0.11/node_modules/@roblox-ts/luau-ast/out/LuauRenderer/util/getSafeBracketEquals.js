"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getSafeBracketEquals = void 0;
function getSafeBracketEquals(str) {
    let amtEquals = 0;
    while (str.includes(`]${"=".repeat(amtEquals)}]`) || str.endsWith(`]${"=".repeat(amtEquals)}`)) {
        amtEquals++;
    }
    return "=".repeat(amtEquals);
}
exports.getSafeBracketEquals = getSafeBracketEquals;
//# sourceMappingURL=getSafeBracketEquals.js.map