"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isSymbolFromRobloxTypes = void 0;
const path_1 = __importDefault(require("path"));
const constants_1 = require("../../Shared/constants");
const isPathDescendantOf_1 = require("../../Shared/util/isPathDescendantOf");
function isSymbolFromRobloxTypes(state, symbol) {
    var _a, _b;
    const filePath = (_b = (_a = symbol === null || symbol === void 0 ? void 0 : symbol.valueDeclaration) === null || _a === void 0 ? void 0 : _a.getSourceFile()) === null || _b === void 0 ? void 0 : _b.fileName;
    const typesPath = path_1.default.join(state.data.nodeModulesPath, constants_1.RBXTS_SCOPE, "types");
    return filePath !== undefined && (0, isPathDescendantOf_1.isPathDescendantOf)(filePath, typesPath);
}
exports.isSymbolFromRobloxTypes = isSymbolFromRobloxTypes;
//# sourceMappingURL=isSymbolFromRobloxTypes.js.map