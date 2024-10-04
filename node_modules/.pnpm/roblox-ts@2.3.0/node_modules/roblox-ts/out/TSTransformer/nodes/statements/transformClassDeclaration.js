"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformClassDeclaration = void 0;
const transformClassLikeDeclaration_1 = require("../class/transformClassLikeDeclaration");
function transformClassDeclaration(state, node) {
    return (0, transformClassLikeDeclaration_1.transformClassLikeDeclaration)(state, node).statements;
}
exports.transformClassDeclaration = transformClassDeclaration;
//# sourceMappingURL=transformClassDeclaration.js.map