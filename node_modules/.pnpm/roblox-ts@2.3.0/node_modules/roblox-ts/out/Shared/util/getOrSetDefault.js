"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getOrSetDefault = void 0;
function getOrSetDefault(map, key, getDefaultValue) {
    let value = map.get(key);
    if (value === undefined) {
        value = getDefaultValue();
        map.set(key, value);
    }
    return value;
}
exports.getOrSetDefault = getOrSetDefault;
//# sourceMappingURL=getOrSetDefault.js.map