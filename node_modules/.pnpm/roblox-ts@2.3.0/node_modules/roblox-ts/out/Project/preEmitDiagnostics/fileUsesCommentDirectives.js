"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fileUsesCommentDirectives = void 0;
const diagnostics_1 = require("../../Shared/diagnostics");
function fileUsesCommentDirectives(data, sourceFile) {
    var _a;
    if (data.projectOptions.allowCommentDirectives) {
        return [];
    }
    const diagnostics = new Array();
    for (const commentDirective of (_a = sourceFile.commentDirectives) !== null && _a !== void 0 ? _a : []) {
        diagnostics.push(diagnostics_1.errors.noCommentDirectives({
            sourceFile,
            range: commentDirective.range,
        }));
    }
    const tsNoCheckPragma = sourceFile.pragmas.get("ts-nocheck");
    if (tsNoCheckPragma) {
        for (const pragma of Array.isArray(tsNoCheckPragma) ? tsNoCheckPragma : [tsNoCheckPragma]) {
            diagnostics.push(diagnostics_1.errors.noCommentDirectives({
                sourceFile,
                range: pragma.range,
            }));
        }
    }
    return diagnostics;
}
exports.fileUsesCommentDirectives = fileUsesCommentDirectives;
//# sourceMappingURL=fileUsesCommentDirectives.js.map