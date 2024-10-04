"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getCustomPreEmitDiagnostics = void 0;
const fileUsesCommentDirectives_1 = require("../preEmitDiagnostics/fileUsesCommentDirectives");
const PRE_EMIT_DIAGNOSTICS = [fileUsesCommentDirectives_1.fileUsesCommentDirectives];
function getCustomPreEmitDiagnostics(data, sourceFile) {
    const diagnostics = new Array();
    for (const check of PRE_EMIT_DIAGNOSTICS) {
        diagnostics.push(...check(data, sourceFile));
    }
    return diagnostics;
}
exports.getCustomPreEmitDiagnostics = getCustomPreEmitDiagnostics;
//# sourceMappingURL=getCustomPreEmitDiagnostics.js.map