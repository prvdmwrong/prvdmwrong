"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createTransformerWatcher = void 0;
const typescript_1 = __importDefault(require("typescript"));
function createServiceHost(program) {
    const rootFileNames = program.getRootFileNames().map(x => x);
    const files = new Map();
    rootFileNames.forEach(fileName => {
        files.set(fileName, 0);
    });
    const overriddenText = new Map();
    function updateFile(fileName, text) {
        var _a;
        overriddenText.set(fileName, text);
        const currentVersion = (_a = files.get(fileName)) !== null && _a !== void 0 ? _a : 0;
        files.set(fileName, currentVersion + 1);
    }
    const serviceHost = {
        getScriptFileNames: () => [...files.keys()].filter(typescript_1.default.sys.fileExists),
        getCurrentDirectory: () => process.cwd(),
        getCompilationSettings: () => program.getCompilerOptions(),
        getDefaultLibFileName: options => typescript_1.default.getDefaultLibFilePath(options),
        fileExists: typescript_1.default.sys.fileExists,
        readDirectory: typescript_1.default.sys.readDirectory,
        directoryExists: typescript_1.default.sys.directoryExists,
        getDirectories: typescript_1.default.sys.getDirectories,
        getScriptVersion,
        getScriptSnapshot,
        readFile,
    };
    function getScriptVersion(fileName) {
        var _a;
        const version = (_a = files.get(fileName)) === null || _a === void 0 ? void 0 : _a.toString();
        return version !== null && version !== void 0 ? version : "0";
    }
    function getScriptSnapshot(fileName) {
        const content = readFile(fileName);
        if (content === undefined)
            return;
        return typescript_1.default.ScriptSnapshot.fromString(content);
    }
    function readFile(fileName, encoding) {
        const content = overriddenText.get(fileName);
        if (content !== undefined)
            return content;
        return typescript_1.default.sys.readFile(fileName, encoding);
    }
    return { serviceHost, updateFile };
}
function createTransformerWatcher(program) {
    const { serviceHost, updateFile } = createServiceHost(program);
    const service = typescript_1.default.createLanguageService(serviceHost, typescript_1.default.createDocumentRegistry());
    return { service, updateFile };
}
exports.createTransformerWatcher = createTransformerWatcher;
//# sourceMappingURL=createTransformerWatcher.js.map