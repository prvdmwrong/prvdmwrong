"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.cleanup = void 0;
const fs_extra_1 = __importDefault(require("fs-extra"));
const path_1 = __importDefault(require("path"));
const tryRemoveOutput_1 = require("./tryRemoveOutput");
function cleanupDirRecursively(pathTranslator, dir) {
    if (fs_extra_1.default.pathExistsSync(dir)) {
        for (const name of fs_extra_1.default.readdirSync(dir)) {
            const itemPath = path_1.default.join(dir, name);
            if (fs_extra_1.default.statSync(itemPath).isDirectory()) {
                if (name === ".git") {
                    continue;
                }
                cleanupDirRecursively(pathTranslator, itemPath);
            }
            (0, tryRemoveOutput_1.tryRemoveOutput)(pathTranslator, itemPath);
        }
    }
}
function cleanup(pathTranslator) {
    const outDir = pathTranslator.outDir;
    if (fs_extra_1.default.pathExistsSync(outDir)) {
        cleanupDirRecursively(pathTranslator, outDir);
    }
}
exports.cleanup = cleanup;
//# sourceMappingURL=cleanup.js.map