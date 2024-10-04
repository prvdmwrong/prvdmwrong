"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LoggableError = void 0;
const LogService_1 = require("../classes/LogService");
class LoggableError {
    constructor() {
        debugger;
    }
    log() {
        LogService_1.LogService.writeLine(this.toString());
    }
}
exports.LoggableError = LoggableError;
//# sourceMappingURL=LoggableError.js.map