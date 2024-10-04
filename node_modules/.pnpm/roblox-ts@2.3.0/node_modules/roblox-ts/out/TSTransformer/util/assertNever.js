"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.assertNever = void 0;
const child_process_1 = require("child_process");
const kleur_1 = __importDefault(require("kleur"));
const LogService_1 = require("../../Shared/classes/LogService");
const getKindName_1 = require("./getKindName");
const typescript_1 = __importDefault(require("typescript"));
const util_1 = __importDefault(require("util"));
function findTypescriptVersion(info) {
    if (info.name === "roblox-ts" && info.dependencies.typescript) {
        return info.dependencies.typescript.version;
    }
    for (const [, dep] of Object.entries(info.dependencies)) {
        const found = findTypescriptVersion(dep);
        if (found) {
            return found;
        }
    }
}
function error(message) {
    const typescriptVersion = findTypescriptVersion(JSON.parse((0, child_process_1.spawnSync)("npm ls typescript --json").stdout.toString()));
    LogService_1.LogService.fatal(kleur_1.default.red(`Exhaustive assertion failed! ${message}`) +
        kleur_1.default.yellow("\nThis is usually caused by a TypeScript version mismatch.") +
        kleur_1.default.yellow("\nMake sure that all TS versions in your project are the same.") +
        kleur_1.default.yellow("\nYou can check the list of installed versions with `npm list typescript`") +
        (typescriptVersion ? kleur_1.default.yellow(`\nTry running \`npm install typescript@=${typescriptVersion}\``) : ""));
}
function assertNever(value, message) {
    const isTsNode = typeof value === "object" && "kind" in value && typescript_1.default.isNode(value);
    error(`${message}, value was ${isTsNode ? `a TS node of kind ${(0, getKindName_1.getKindName)(value.kind)}` : util_1.default.inspect(value)}`);
}
exports.assertNever = assertNever;
//# sourceMappingURL=assertNever.js.map