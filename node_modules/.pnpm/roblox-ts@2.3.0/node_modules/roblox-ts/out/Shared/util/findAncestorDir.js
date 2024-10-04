"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.findAncestorDir = void 0;
const path_1 = __importDefault(require("path"));
function findAncestorDir(dirs) {
    dirs = dirs.map(path_1.default.normalize).map(v => (v.endsWith(path_1.default.sep) ? v : v + path_1.default.sep));
    let currentDir = dirs[0];
    while (!dirs.every(v => v.startsWith(currentDir))) {
        currentDir = path_1.default.join(currentDir, "..");
    }
    return currentDir;
}
exports.findAncestorDir = findAncestorDir;
//# sourceMappingURL=findAncestorDir.js.map