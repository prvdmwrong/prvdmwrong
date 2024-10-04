"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformTypeExpression = void 0;
const transformExpression_1 = require("./transformExpression");
function transformTypeExpression(state, node) {
    return (0, transformExpression_1.transformExpression)(state, node.expression);
}
exports.transformTypeExpression = transformTypeExpression;
//# sourceMappingURL=transformTypeExpression.js.map