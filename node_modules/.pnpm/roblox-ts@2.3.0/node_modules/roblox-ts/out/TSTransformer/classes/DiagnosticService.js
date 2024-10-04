"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DiagnosticService = void 0;
const hasErrors_1 = require("../../Shared/util/hasErrors");
class DiagnosticService {
    static addSingleDiagnostic(diagnostic) {
        if (!this.singleDiagnostics.has(diagnostic.code)) {
            this.singleDiagnostics.add(diagnostic.code);
            this.addDiagnostic(diagnostic);
        }
    }
    static addDiagnostic(diagnostic) {
        this.diagnostics.push(diagnostic);
    }
    static addDiagnostics(diagnostics) {
        this.diagnostics.push(...diagnostics);
    }
    static addDiagnosticWithCache(cacheBy, diagnostic, cache) {
        if (!cache.has(cacheBy)) {
            cache.add(cacheBy);
            this.addDiagnostic(diagnostic);
        }
    }
    static flush() {
        const current = this.diagnostics;
        this.diagnostics = [];
        this.singleDiagnostics.clear();
        return current;
    }
    static hasErrors() {
        return (0, hasErrors_1.hasErrors)(this.diagnostics);
    }
}
exports.DiagnosticService = DiagnosticService;
DiagnosticService.diagnostics = new Array();
DiagnosticService.singleDiagnostics = new Set();
//# sourceMappingURL=DiagnosticService.js.map