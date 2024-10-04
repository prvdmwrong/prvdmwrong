"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isPathDescendantOf = void 0;
const path_1 = __importDefault(require("path"));
function isPathDescendantOf(filePath, dirPath) {
    return dirPath === filePath || !path_1.default.relative(dirPath, filePath).startsWith("..");
}
exports.isPathDescendantOf = isPathDescendantOf;
//# sourceMappingURL=isPathDescendantOf.js.map