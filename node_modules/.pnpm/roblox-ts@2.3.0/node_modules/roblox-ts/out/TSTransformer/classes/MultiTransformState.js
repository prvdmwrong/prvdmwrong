"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MultiTransformState = void 0;
class MultiTransformState {
    constructor() {
        this.isMethodCache = new Map();
        this.isDefinedAsLetCache = new Map();
        this.isReportedByNoAnyCache = new Set();
        this.isReportedByMultipleDefinitionsCache = new Set();
        this.getModuleExportsCache = new Map();
        this.getModuleExportsAliasMapCache = new Map();
    }
}
exports.MultiTransformState = MultiTransformState;
//# sourceMappingURL=MultiTransformState.js.map