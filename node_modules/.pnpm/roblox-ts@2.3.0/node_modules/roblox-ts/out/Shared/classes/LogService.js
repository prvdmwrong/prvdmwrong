"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LogService = void 0;
const kleur_1 = __importDefault(require("kleur"));
class LogService {
    static write(message) {
        this.partial = !message.endsWith("\n");
        process.stdout.write(message);
    }
    static writeLine(...messages) {
        if (this.partial) {
            this.write("\n");
        }
        for (const message of messages) {
            this.write(message + "\n");
        }
    }
    static writeLineIfVerbose(...messages) {
        if (this.verbose) {
            this.writeLine(...messages);
        }
    }
    static warn(message) {
        this.writeLine(`${kleur_1.default.yellow("Compiler Warning:")} ${message}`);
    }
    static fatal(message) {
        this.writeLine(message);
        process.exit(1);
    }
}
exports.LogService = LogService;
LogService.verbose = false;
LogService.partial = false;
//# sourceMappingURL=LogService.js.map