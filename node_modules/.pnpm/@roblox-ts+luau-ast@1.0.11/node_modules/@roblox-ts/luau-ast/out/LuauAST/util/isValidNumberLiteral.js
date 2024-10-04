"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isValidNumberLiteral = void 0;
const DECIMAL_LITERAL_REGEX = /^(?:\d[\d_]*(?:\.[\d_]*)?|\.\d[\d_]*)(?:[eE][+-]?_*\d[\d_]*)?$/;
const BINARY_LITERAL_REGEX = /^0_*[bB]_*[01][01_]*$/;
const HEXADECIMAL_LITERAL_REGEX = /^0_*[xX]_*[\da-fA-F][\da-fA-F_]*$/;
function isValidNumberLiteral(text) {
    return DECIMAL_LITERAL_REGEX.test(text) || BINARY_LITERAL_REGEX.test(text) || HEXADECIMAL_LITERAL_REGEX.test(text);
}
exports.isValidNumberLiteral = isValidNumberLiteral;
//# sourceMappingURL=isValidNumberLiteral.js.map