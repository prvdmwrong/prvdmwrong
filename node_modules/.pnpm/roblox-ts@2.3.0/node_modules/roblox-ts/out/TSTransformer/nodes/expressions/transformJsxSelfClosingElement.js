"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformJsxSelfClosingElement = void 0;
const transformJsx_1 = require("../jsx/transformJsx");
function transformJsxSelfClosingElement(state, node) {
    return (0, transformJsx_1.transformJsx)(state, node, node.tagName, node.attributes, []);
}
exports.transformJsxSelfClosingElement = transformJsxSelfClosingElement;
//# sourceMappingURL=transformJsxSelfClosingElement.js.map