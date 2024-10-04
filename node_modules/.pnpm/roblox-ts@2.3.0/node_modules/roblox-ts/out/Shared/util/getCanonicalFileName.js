"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var _a, _b;
Object.defineProperty(exports, "__esModule", { value: true });
exports.getCanonicalFileName = void 0;
const typescript_1 = __importDefault(require("typescript"));
exports.getCanonicalFileName = typescript_1.default.createGetCanonicalFileName((_b = (_a = typescript_1.default.sys) === null || _a === void 0 ? void 0 : _a.useCaseSensitiveFileNames) !== null && _b !== void 0 ? _b : true);
//# sourceMappingURL=getCanonicalFileName.js.map