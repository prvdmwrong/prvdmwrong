"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createProjectProgram = void 0;
const createProgramFactory_1 = require("./createProgramFactory");
const getParsedCommandLine_1 = require("./getParsedCommandLine");
function createProjectProgram(data, host) {
    const { fileNames, options } = (0, getParsedCommandLine_1.getParsedCommandLine)(data);
    const createProgram = (0, createProgramFactory_1.createProgramFactory)(data, options);
    return createProgram(fileNames, options, host);
}
exports.createProjectProgram = createProjectProgram;
//# sourceMappingURL=createProjectProgram.js.map