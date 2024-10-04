"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getChangedFilePaths = void 0;
const getCanonicalFileName_1 = require("../../Shared/util/getCanonicalFileName");
const getOrSetDefault_1 = require("../../Shared/util/getOrSetDefault");
const typescript_1 = __importDefault(require("typescript"));
function getChangedFilePaths(program, pathHints) {
    var _a, _b, _c;
    const compilerOptions = program.getCompilerOptions();
    const buildState = program.getState();
    const reversedReferencedMap = new Map();
    const referencedMap = buildState.referencedMap;
    if (referencedMap) {
        for (const filePath of typescript_1.default.arrayFrom(referencedMap.keys())) {
            (_a = referencedMap.getValues(filePath)) === null || _a === void 0 ? void 0 : _a.forEach((_, refFilePath) => {
                (0, getOrSetDefault_1.getOrSetDefault)(reversedReferencedMap, refFilePath, () => new Set()).add(filePath);
            });
        }
    }
    const changedFilesSet = new Set();
    const search = (filePath) => {
        var _a;
        changedFilesSet.add(filePath);
        (_a = reversedReferencedMap.get(filePath)) === null || _a === void 0 ? void 0 : _a.forEach(refFilePath => {
            if (!changedFilesSet.has(refFilePath)) {
                changedFilesSet.add(refFilePath);
                if (compilerOptions.assumeChangesOnlyAffectDirectDependencies !== true) {
                    search(refFilePath);
                }
            }
        });
    };
    if (pathHints) {
        for (const hint of pathHints) {
            search((0, getCanonicalFileName_1.getCanonicalFileName)(hint));
        }
    }
    else {
        (_b = buildState.changedFilesSet) === null || _b === void 0 ? void 0 : _b.forEach((_, fileName) => search(fileName));
        (_c = buildState.changedFilesSet) === null || _c === void 0 ? void 0 : _c.clear();
    }
    return changedFilesSet;
}
exports.getChangedFilePaths = getChangedFilePaths;
//# sourceMappingURL=getChangedFilePaths.js.map