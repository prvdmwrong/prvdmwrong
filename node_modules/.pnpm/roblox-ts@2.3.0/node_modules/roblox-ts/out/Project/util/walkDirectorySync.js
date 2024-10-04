"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.walkDirectorySync = void 0;
const fs_extra_1 = __importDefault(require("fs-extra"));
const path_1 = __importDefault(require("path"));
function walkDirectorySync(dir, callback) {
    const queue = [dir];
    for (let i = 0; i < queue.length; i++) {
        const currentDir = queue[i];
        for (const child of fs_extra_1.default.readdirSync(currentDir)) {
            const fsPath = path_1.default.join(currentDir, child);
            callback(fsPath);
            if (fs_extra_1.default.statSync(fsPath).isDirectory()) {
                queue.push(fsPath);
            }
        }
    }
}
exports.walkDirectorySync = walkDirectorySync;
//# sourceMappingURL=walkDirectorySync.js.map