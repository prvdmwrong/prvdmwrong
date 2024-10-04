"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.realPathExistsSync = void 0;
const fs_extra_1 = __importDefault(require("fs-extra"));
function realPathExistsSync(fsPath) {
    if (fs_extra_1.default.pathExistsSync(fsPath)) {
        return fs_extra_1.default.realpathSync(fsPath);
    }
}
exports.realPathExistsSync = realPathExistsSync;
//# sourceMappingURL=realPathExistsSync.js.map