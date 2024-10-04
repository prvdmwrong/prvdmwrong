"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
const CLIError_1 = require("../errors/CLIError");
const fs_extra_1 = __importDefault(require("fs-extra"));
const path_1 = __importDefault(require("path"));
const cleanup_1 = require("../../Project/functions/cleanup");
const compileFiles_1 = require("../../Project/functions/compileFiles");
const copyFiles_1 = require("../../Project/functions/copyFiles");
const copyInclude_1 = require("../../Project/functions/copyInclude");
const createPathTranslator_1 = require("../../Project/functions/createPathTranslator");
const createProjectData_1 = require("../../Project/functions/createProjectData");
const createProjectProgram_1 = require("../../Project/functions/createProjectProgram");
const getChangedSourceFiles_1 = require("../../Project/functions/getChangedSourceFiles");
const setupProjectWatchProgram_1 = require("../../Project/functions/setupProjectWatchProgram");
const LogService_1 = require("../../Shared/classes/LogService");
const constants_1 = require("../../Shared/constants");
const LoggableError_1 = require("../../Shared/errors/LoggableError");
const getRootDirs_1 = require("../../Shared/util/getRootDirs");
const hasErrors_1 = require("../../Shared/util/hasErrors");
const typescript_1 = __importDefault(require("typescript"));
const yargs_1 = __importDefault(require("yargs"));
function getTsConfigProjectOptions(tsConfigPath) {
    if (tsConfigPath !== undefined) {
        const rawJson = typescript_1.default.sys.readFile(tsConfigPath);
        if (rawJson !== undefined) {
            return typescript_1.default.parseConfigFileTextToJson(tsConfigPath, rawJson).config.rbxts;
        }
    }
}
function findTsConfigPath(projectPath) {
    let tsConfigPath = path_1.default.resolve(projectPath);
    if (!fs_extra_1.default.existsSync(tsConfigPath) || !fs_extra_1.default.statSync(tsConfigPath).isFile()) {
        tsConfigPath = typescript_1.default.findConfigFile(tsConfigPath, typescript_1.default.sys.fileExists);
        if (tsConfigPath === undefined) {
            throw new CLIError_1.CLIError("Unable to find tsconfig.json!");
        }
    }
    return path_1.default.resolve(process.cwd(), tsConfigPath);
}
module.exports = typescript_1.default.identity({
    command: ["$0", "build"],
    describe: "Build a project",
    builder: () => yargs_1.default
        .option("project", {
        alias: "p",
        string: true,
        default: ".",
        describe: "project path",
    })
        .option("watch", {
        alias: "w",
        boolean: true,
        describe: "enable watch mode",
    })
        .option("usePolling", {
        implies: "watch",
        boolean: true,
        describe: "use polling for watch mode",
    })
        .option("verbose", {
        boolean: true,
        describe: "enable verbose logs",
    })
        .option("noInclude", {
        boolean: true,
        describe: "do not copy include files",
    })
        .option("logTruthyChanges", {
        boolean: true,
        describe: "logs changes to truthiness evaluation from Lua truthiness rules",
    })
        .option("writeOnlyChanged", {
        boolean: true,
        hidden: true,
    })
        .option("writeTransformedFiles", {
        boolean: true,
        hidden: true,
        describe: "writes resulting TypeScript ASTs after transformers to out directory",
    })
        .option("optimizedLoops", {
        boolean: true,
        hidden: true,
    })
        .option("type", {
        choices: [constants_1.ProjectType.Game, constants_1.ProjectType.Model, constants_1.ProjectType.Package],
        describe: "override project type",
    })
        .option("includePath", {
        alias: "i",
        string: true,
        describe: "folder to copy runtime files to",
    })
        .option("rojo", {
        string: true,
        describe: "manually select Rojo project file",
    })
        .option("allowCommentDirectives", {
        boolean: true,
        hidden: true,
    }),
    handler: async (argv) => {
        try {
            const tsConfigPath = findTsConfigPath(argv.project);
            const projectOptions = Object.assign({}, constants_1.DEFAULT_PROJECT_OPTIONS, getTsConfigProjectOptions(tsConfigPath), argv);
            LogService_1.LogService.verbose = projectOptions.verbose === true;
            const diagnosticReporter = typescript_1.default.createDiagnosticReporter(typescript_1.default.sys, true);
            const data = (0, createProjectData_1.createProjectData)(tsConfigPath, projectOptions);
            if (projectOptions.watch) {
                (0, setupProjectWatchProgram_1.setupProjectWatchProgram)(data, projectOptions.usePolling);
            }
            else {
                const program = (0, createProjectProgram_1.createProjectProgram)(data);
                const pathTranslator = (0, createPathTranslator_1.createPathTranslator)(program);
                (0, cleanup_1.cleanup)(pathTranslator);
                (0, copyInclude_1.copyInclude)(data);
                (0, copyFiles_1.copyFiles)(data, pathTranslator, new Set((0, getRootDirs_1.getRootDirs)(program.getCompilerOptions())));
                const emitResult = (0, compileFiles_1.compileFiles)(program.getProgram(), data, pathTranslator, (0, getChangedSourceFiles_1.getChangedSourceFiles)(program));
                for (const diagnostic of emitResult.diagnostics) {
                    diagnosticReporter(diagnostic);
                }
                if ((0, hasErrors_1.hasErrors)(emitResult.diagnostics)) {
                    process.exitCode = 1;
                }
            }
        }
        catch (e) {
            process.exitCode = 1;
            if (e instanceof LoggableError_1.LoggableError) {
                e.log();
                debugger;
            }
            else {
                throw e;
            }
        }
    },
});
//# sourceMappingURL=build.js.map