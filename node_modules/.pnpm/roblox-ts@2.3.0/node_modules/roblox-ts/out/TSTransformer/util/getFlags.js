"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getFlags = void 0;
function getFlags(flags, from) {
    const results = new Array();
    for (const [flagName, flagValue] of Object.entries(from)) {
        if (!!(flags & flagValue)) {
            results.push(flagName);
        }
    }
    return results;
}
exports.getFlags = getFlags;
//# sourceMappingURL=getFlags.js.map