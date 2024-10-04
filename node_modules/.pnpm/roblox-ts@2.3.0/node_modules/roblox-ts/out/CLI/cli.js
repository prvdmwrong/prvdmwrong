#!/usr/bin/env node
"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const CLIError_1 = require("./errors/CLIError");
const constants_1 = require("../Shared/constants");
const yargs_1 = __importDefault(require("yargs"));
yargs_1.default
    .usage("roblox-ts - A TypeScript-to-Luau Compiler for Roblox")
    .help("help")
    .alias("h", "help")
    .describe("help", "show help information")
    .version(constants_1.COMPILER_VERSION)
    .alias("v", "version")
    .describe("version", "show version information")
    .commandDir(`${constants_1.PACKAGE_ROOT}/out/CLI/commands`)
    .recommendCommands()
    .strict()
    .wrap(yargs_1.default.terminalWidth())
    .fail(str => {
    process.exitCode = 1;
    if (str) {
        console.log(str);
    }
})
    .parseAsync()
    .catch(e => {
    if (e instanceof CLIError_1.CLIError) {
        e.log();
        debugger;
    }
    else {
        throw e;
    }
});
//# sourceMappingURL=cli.js.map