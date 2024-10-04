"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getStatements = void 0;
const typescript_1 = __importDefault(require("typescript"));
function getStatements(statement) {
    return typescript_1.default.isBlock(statement) ? statement.statements : [statement];
}
exports.getStatements = getStatements;
//# sourceMappingURL=getStatements.js.map