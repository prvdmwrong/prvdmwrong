"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createDiagnosticWithLocation = void 0;
function createDiagnosticWithLocation(id, messageText, category, node) {
    const code = " roblox-ts";
    const diagnosticType = 0;
    if ("kind" in node) {
        return {
            category,
            code,
            messageText,
            diagnosticType,
            id,
            file: node.getSourceFile(),
            start: node.getStart(),
            length: node.getWidth(),
        };
    }
    else {
        return {
            category,
            code,
            messageText,
            diagnosticType,
            id,
            file: node.sourceFile,
            start: node.range.pos,
            length: node.range.end,
        };
    }
}
exports.createDiagnosticWithLocation = createDiagnosticWithLocation;
//# sourceMappingURL=createDiagnosticWithLocation.js.map