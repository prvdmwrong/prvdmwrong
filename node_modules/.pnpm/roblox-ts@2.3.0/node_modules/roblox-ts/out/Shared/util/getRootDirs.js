"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getRootDirs = void 0;
const assert_1 = require("./assert");
function getRootDirs(compilerOptions) {
    const rootDirs = compilerOptions.rootDir ? [compilerOptions.rootDir] : compilerOptions.rootDirs;
    (0, assert_1.assert)(rootDirs);
    return rootDirs;
}
exports.getRootDirs = getRootDirs;
//# sourceMappingURL=getRootDirs.js.map