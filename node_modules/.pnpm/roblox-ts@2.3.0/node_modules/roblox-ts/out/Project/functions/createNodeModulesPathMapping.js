"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createNodeModulesPathMapping = void 0;
const fs_extra_1 = __importDefault(require("fs-extra"));
const path_1 = __importDefault(require("path"));
const getCanonicalFileName_1 = require("../../Shared/util/getCanonicalFileName");
const realPathExistsSync_1 = require("../../Shared/util/realPathExistsSync");
function createNodeModulesPathMapping(typeRoots) {
    var _a, _b;
    const nodeModulesPathMapping = new Map();
    for (const scopePath of typeRoots) {
        if (fs_extra_1.default.pathExistsSync(scopePath)) {
            for (const pkgName of fs_extra_1.default.readdirSync(scopePath)) {
                const pkgPath = path_1.default.join(scopePath, pkgName);
                const pkgJsonPath = (0, realPathExistsSync_1.realPathExistsSync)(path_1.default.join(pkgPath, "package.json"));
                if (pkgJsonPath !== undefined) {
                    const pkgJson = fs_extra_1.default.readJsonSync(pkgJsonPath);
                    const typesPath = (_b = (_a = pkgJson.types) !== null && _a !== void 0 ? _a : pkgJson.typings) !== null && _b !== void 0 ? _b : "index.d.ts";
                    if (pkgJson.main) {
                        nodeModulesPathMapping.set((0, getCanonicalFileName_1.getCanonicalFileName)(path_1.default.resolve(pkgPath, typesPath)), path_1.default.resolve(pkgPath, pkgJson.main));
                    }
                }
            }
        }
    }
    return nodeModulesPathMapping;
}
exports.createNodeModulesPathMapping = createNodeModulesPathMapping;
//# sourceMappingURL=createNodeModulesPathMapping.js.map