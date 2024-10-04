"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformTypeReferenceDirectives = void 0;
const typescript_1 = __importDefault(require("typescript"));
const SCOPE = "@rbxts/";
const PACKAGE = "types";
function transformTypeReferenceDirectives() {
    return (sourceFile) => {
        if (typescript_1.default.isSourceFile(sourceFile)) {
            for (const typeReferenceDirective of sourceFile.typeReferenceDirectives) {
                if (typeReferenceDirective.fileName === PACKAGE) {
                    typeReferenceDirective.fileName = SCOPE + PACKAGE;
                    typeReferenceDirective.end += SCOPE.length;
                }
            }
        }
        return sourceFile;
    };
}
exports.transformTypeReferenceDirectives = transformTypeReferenceDirectives;
//# sourceMappingURL=transformTypeReferenceDirectives.js.map