"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isCompilableFile = void 0;
const fs_extra_1 = __importDefault(require("fs-extra"));
const constants_1 = require("../../Shared/constants");
function isCompilableFile(fsPath) {
    if (fs_extra_1.default.statSync(fsPath).isDirectory()) {
        return false;
    }
    if (fsPath.endsWith(constants_1.DTS_EXT)) {
        return false;
    }
    return fsPath.endsWith(constants_1.TS_EXT) || fsPath.endsWith(constants_1.TSX_EXT);
}
exports.isCompilableFile = isCompilableFile;
//# sourceMappingURL=isCompilableFile.js.map