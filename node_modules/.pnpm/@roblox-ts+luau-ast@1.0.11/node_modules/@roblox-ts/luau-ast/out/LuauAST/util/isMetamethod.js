"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isMetamethod = void 0;
const LUAU_METAMETHODS = new Set([
    "__index",
    "__newindex",
    "__call",
    "__concat",
    "__unm",
    "__add",
    "__sub",
    "__mul",
    "__div",
    "__mod",
    "__pow",
    "__tostring",
    "__metatable",
    "__eq",
    "__lt",
    "__le",
    "__mode",
    "__gc",
    "__len",
]);
function isMetamethod(id) {
    return LUAU_METAMETHODS.has(id);
}
exports.isMetamethod = isMetamethod;
//# sourceMappingURL=isMetamethod.js.map