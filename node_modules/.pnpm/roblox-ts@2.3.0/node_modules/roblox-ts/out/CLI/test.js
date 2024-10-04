"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs_extra_1 = __importDefault(require("fs-extra"));
const mocha_1 = require("mocha");
const path_1 = __importDefault(require("path"));
const compileFiles_1 = require("../Project/functions/compileFiles");
const copyFiles_1 = require("../Project/functions/copyFiles");
const copyInclude_1 = require("../Project/functions/copyInclude");
const createPathTranslator_1 = require("../Project/functions/createPathTranslator");
const createProjectData_1 = require("../Project/functions/createProjectData");
const createProjectProgram_1 = require("../Project/functions/createProjectProgram");
const getChangedSourceFiles_1 = require("../Project/functions/getChangedSourceFiles");
const constants_1 = require("../Shared/constants");
const diagnostics_1 = require("../Shared/diagnostics");
const assert_1 = require("../Shared/util/assert");
const formatDiagnostics_1 = require("../Shared/util/formatDiagnostics");
const getRootDirs_1 = require("../Shared/util/getRootDirs");
const isPathDescendantOf_1 = require("../Shared/util/isPathDescendantOf");
const DIAGNOSTIC_TEST_NAME_REGEX = /^(\w+)(?:\.\d+)?$/;
(0, mocha_1.describe)("should compile tests project", () => {
    var _a;
    const data = (0, createProjectData_1.createProjectData)(path_1.default.join(constants_1.PACKAGE_ROOT, "tests", "tsconfig.json"), Object.assign({}, constants_1.DEFAULT_PROJECT_OPTIONS, {
        project: "",
        allowCommentDirectives: true,
        optimizedLoops: true,
    }));
    const program = (0, createProjectProgram_1.createProjectProgram)(data);
    const pathTranslator = (0, createPathTranslator_1.createPathTranslator)(program);
    fs_extra_1.default.removeSync(program.getCompilerOptions().outDir);
    it("should copy include files", () => (0, copyInclude_1.copyInclude)(data));
    it("should copy non-compiled files", () => (0, copyFiles_1.copyFiles)(data, pathTranslator, new Set((0, getRootDirs_1.getRootDirs)(program.getCompilerOptions()))));
    const diagnosticsFolder = path_1.default.join(constants_1.PACKAGE_ROOT, "tests", "src", "diagnostics");
    for (const sourceFile of (0, getChangedSourceFiles_1.getChangedSourceFiles)(program)) {
        const fileName = path_1.default.relative(process.cwd(), sourceFile.fileName);
        if ((0, isPathDescendantOf_1.isPathDescendantOf)(path_1.default.normalize(sourceFile.fileName), diagnosticsFolder)) {
            let fileBaseName = path_1.default.basename(sourceFile.fileName);
            const ext = path_1.default.extname(fileBaseName);
            if (ext === constants_1.TS_EXT || ext === constants_1.TSX_EXT) {
                fileBaseName = path_1.default.basename(sourceFile.fileName, ext);
            }
            const diagnosticName = (_a = fileBaseName.match(DIAGNOSTIC_TEST_NAME_REGEX)) === null || _a === void 0 ? void 0 : _a[1];
            (0, assert_1.assert)(diagnosticName && diagnostics_1.errors[diagnosticName], `Diagnostic test for unknown diagnostic ${fileBaseName}`);
            const expectedId = diagnostics_1.errors[diagnosticName].id;
            it(`should compile ${fileName} and report diagnostic ${diagnosticName}`, done => {
                const emitResult = (0, compileFiles_1.compileFiles)(program.getProgram(), data, pathTranslator, [sourceFile]);
                if (emitResult.diagnostics.length > 0 &&
                    emitResult.diagnostics.every(d => (0, diagnostics_1.getDiagnosticId)(d) === expectedId)) {
                    done();
                }
                else if (emitResult.diagnostics.length === 0) {
                    done(new Error(`Expected diagnostic ${diagnosticName} to be reported.`));
                }
                else {
                    done(new Error("Unexpected diagnostics:\n" + (0, formatDiagnostics_1.formatDiagnostics)(emitResult.diagnostics)));
                }
            });
        }
        else {
            it(`should compile ${fileName}`, done => {
                const emitResult = (0, compileFiles_1.compileFiles)(program.getProgram(), data, pathTranslator, [sourceFile]);
                if (emitResult.diagnostics.length > 0) {
                    done(new Error("\n" + (0, formatDiagnostics_1.formatDiagnostics)(emitResult.diagnostics)));
                }
                else {
                    done();
                }
            });
        }
    }
});
//# sourceMappingURL=test.js.map