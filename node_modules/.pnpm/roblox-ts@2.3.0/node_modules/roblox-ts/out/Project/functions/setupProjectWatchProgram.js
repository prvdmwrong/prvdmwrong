"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.setupProjectWatchProgram = void 0;
const chokidar_1 = __importDefault(require("chokidar"));
const fs_extra_1 = __importDefault(require("fs-extra"));
const checkFileName_1 = require("./checkFileName");
const cleanup_1 = require("./cleanup");
const compileFiles_1 = require("./compileFiles");
const copyFiles_1 = require("./copyFiles");
const copyInclude_1 = require("./copyInclude");
const copyItem_1 = require("./copyItem");
const createPathTranslator_1 = require("./createPathTranslator");
const createProgramFactory_1 = require("./createProgramFactory");
const getChangedSourceFiles_1 = require("./getChangedSourceFiles");
const getParsedCommandLine_1 = require("./getParsedCommandLine");
const tryRemoveOutput_1 = require("./tryRemoveOutput");
const isCompilableFile_1 = require("../util/isCompilableFile");
const walkDirectorySync_1 = require("../util/walkDirectorySync");
const DiagnosticError_1 = require("../../Shared/errors/DiagnosticError");
const assert_1 = require("../../Shared/util/assert");
const getRootDirs_1 = require("../../Shared/util/getRootDirs");
const typescript_1 = __importDefault(require("typescript"));
const CHOKIDAR_OPTIONS = {
    awaitWriteFinish: {
        pollInterval: 10,
        stabilityThreshold: 50,
    },
    ignoreInitial: true,
    disableGlobbing: true,
};
function fixSlashes(fsPath) {
    return fsPath.replace(/\\/g, "/");
}
function setupProjectWatchProgram(data, usePolling) {
    const { fileNames, options } = (0, getParsedCommandLine_1.getParsedCommandLine)(data);
    const fileNamesSet = new Set(fileNames);
    let initialCompileCompleted = false;
    let collecting = false;
    let filesToAdd = new Set();
    let filesToChange = new Set();
    let filesToDelete = new Set();
    const watchReporter = typescript_1.default.createWatchStatusReporter(typescript_1.default.sys, true);
    const diagnosticReporter = typescript_1.default.createDiagnosticReporter(typescript_1.default.sys, true);
    function reportText(messageText) {
        watchReporter({
            category: typescript_1.default.DiagnosticCategory.Message,
            messageText,
            code: 0,
            file: undefined,
            length: undefined,
            start: undefined,
        }, typescript_1.default.sys.newLine, options);
    }
    function reportEmitResult(emitResult) {
        for (const diagnostic of emitResult.diagnostics) {
            diagnosticReporter(diagnostic);
        }
        const amtErrors = emitResult.diagnostics.filter(v => v.category === typescript_1.default.DiagnosticCategory.Error).length;
        reportText(`Found ${amtErrors} error${amtErrors === 1 ? "" : "s"}. Watching for file changes.`);
    }
    let program;
    let pathTranslator;
    const createProgram = (0, createProgramFactory_1.createProgramFactory)(data, options);
    function refreshProgram() {
        program = createProgram([...fileNamesSet], options);
        pathTranslator = (0, createPathTranslator_1.createPathTranslator)(program);
    }
    function runInitialCompile() {
        refreshProgram();
        (0, assert_1.assert)(program && pathTranslator);
        (0, cleanup_1.cleanup)(pathTranslator);
        (0, copyInclude_1.copyInclude)(data);
        (0, copyFiles_1.copyFiles)(data, pathTranslator, new Set((0, getRootDirs_1.getRootDirs)(options)));
        const sourceFiles = (0, getChangedSourceFiles_1.getChangedSourceFiles)(program);
        const emitResult = (0, compileFiles_1.compileFiles)(program.getProgram(), data, pathTranslator, sourceFiles);
        if (!emitResult.emitSkipped) {
            initialCompileCompleted = true;
        }
        return emitResult;
    }
    const filesToCompile = new Set();
    const filesToCopy = new Set();
    const filesToClean = new Set();
    function runIncrementalCompile(additions, changes, removals) {
        for (const fsPath of additions) {
            if (fs_extra_1.default.statSync(fsPath).isDirectory()) {
                (0, walkDirectorySync_1.walkDirectorySync)(fsPath, item => {
                    if ((0, isCompilableFile_1.isCompilableFile)(item)) {
                        fileNamesSet.add(item);
                        filesToCompile.add(item);
                    }
                });
            }
            else if ((0, isCompilableFile_1.isCompilableFile)(fsPath)) {
                fileNamesSet.add(fsPath);
                filesToCompile.add(fsPath);
            }
            else {
                (0, checkFileName_1.checkFileName)(fsPath);
                filesToCopy.add(fsPath);
            }
        }
        for (const fsPath of changes) {
            if ((0, isCompilableFile_1.isCompilableFile)(fsPath)) {
                filesToCompile.add(fsPath);
            }
            else {
                const transformerWatcher = data.transformerWatcher;
                if (transformerWatcher) {
                    const contents = typescript_1.default.sys.readFile(fsPath);
                    if (contents) {
                        transformerWatcher.updateFile(fsPath, contents);
                    }
                }
                filesToCopy.add(fsPath);
            }
        }
        for (const fsPath of removals) {
            fileNamesSet.delete(fsPath);
            filesToClean.add(fsPath);
        }
        refreshProgram();
        (0, assert_1.assert)(program && pathTranslator);
        const sourceFiles = (0, getChangedSourceFiles_1.getChangedSourceFiles)(program, options.incremental ? undefined : [...filesToCompile]);
        const emitResult = (0, compileFiles_1.compileFiles)(program.getProgram(), data, pathTranslator, sourceFiles);
        if (emitResult.emitSkipped) {
            return emitResult;
        }
        for (const fsPath of filesToClean) {
            (0, tryRemoveOutput_1.tryRemoveOutput)(pathTranslator, pathTranslator.getOutputPath(fsPath));
            if (options.declaration) {
                (0, tryRemoveOutput_1.tryRemoveOutput)(pathTranslator, pathTranslator.getOutputDeclarationPath(fsPath));
            }
        }
        for (const fsPath of filesToCopy) {
            (0, copyItem_1.copyItem)(data, pathTranslator, fsPath);
        }
        filesToCompile.clear();
        filesToCopy.clear();
        filesToClean.clear();
        return emitResult;
    }
    function runCompile() {
        try {
            if (!initialCompileCompleted) {
                return runInitialCompile();
            }
            else {
                const additions = filesToAdd;
                const changes = filesToChange;
                const removals = filesToDelete;
                filesToAdd = new Set();
                filesToChange = new Set();
                filesToDelete = new Set();
                return runIncrementalCompile(additions, changes, removals);
            }
        }
        catch (e) {
            if (e instanceof DiagnosticError_1.DiagnosticError) {
                return {
                    emitSkipped: true,
                    diagnostics: e.diagnostics,
                };
            }
            else {
                throw e;
            }
        }
    }
    function closeEventCollection() {
        collecting = false;
        reportEmitResult(runCompile());
    }
    function openEventCollection() {
        if (!collecting) {
            collecting = true;
            reportText("File change detected. Starting incremental compilation...");
            setTimeout(closeEventCollection, 100);
        }
    }
    function collectAddEvent(fsPath) {
        filesToAdd.add(fixSlashes(fsPath));
        openEventCollection();
    }
    function collectChangeEvent(fsPath) {
        filesToChange.add(fixSlashes(fsPath));
        openEventCollection();
    }
    function collectDeleteEvent(fsPath) {
        filesToDelete.add(fixSlashes(fsPath));
        openEventCollection();
    }
    const chokidarOptions = { ...CHOKIDAR_OPTIONS, usePolling };
    chokidar_1.default
        .watch((0, getRootDirs_1.getRootDirs)(options), chokidarOptions)
        .on("add", collectAddEvent)
        .on("addDir", collectAddEvent)
        .on("change", collectChangeEvent)
        .on("unlink", collectDeleteEvent)
        .on("unlinkDir", collectDeleteEvent)
        .once("ready", () => {
        reportText("Starting compilation in watch mode...");
        reportEmitResult(runCompile());
    });
}
exports.setupProjectWatchProgram = setupProjectWatchProgram;
//# sourceMappingURL=setupProjectWatchProgram.js.map