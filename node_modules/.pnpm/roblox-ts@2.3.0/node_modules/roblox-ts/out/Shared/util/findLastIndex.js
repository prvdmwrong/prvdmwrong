"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.findLastIndex = void 0;
function findLastIndex(array, callback) {
    for (let i = array.length - 1; i >= 0; i--) {
        if (callback(array[i])) {
            return i;
        }
    }
    return -1;
}
exports.findLastIndex = findLastIndex;
//# sourceMappingURL=findLastIndex.js.map