"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getChangedSourceFiles = void 0;
const getChangedFilePaths_1 = require("./getChangedFilePaths");
const typescript_1 = __importDefault(require("typescript"));
function getChangedSourceFiles(program, pathHints) {
    const sourceFiles = new Array();
    for (const fileName of (0, getChangedFilePaths_1.getChangedFilePaths)(program, pathHints)) {
        const sourceFile = program.getSourceFile(fileName);
        if (sourceFile && !sourceFile.isDeclarationFile && !typescript_1.default.isJsonSourceFile(sourceFile)) {
            sourceFiles.push(sourceFile);
        }
    }
    return sourceFiles;
}
exports.getChangedSourceFiles = getChangedSourceFiles;
//# sourceMappingURL=getChangedSourceFiles.js.map