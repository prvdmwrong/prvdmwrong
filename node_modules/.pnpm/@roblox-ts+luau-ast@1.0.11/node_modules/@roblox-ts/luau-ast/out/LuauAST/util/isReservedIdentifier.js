"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isReservedIdentifier = void 0;
const globals_1 = require("../impl/globals");
function isReservedIdentifier(id) {
    return Object.prototype.hasOwnProperty.call(globals_1.globals, id);
}
exports.isReservedIdentifier = isReservedIdentifier;
//# sourceMappingURL=isReservedIdentifier.js.map