"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.benchmark = exports.benchmarkIfVerbose = exports.benchmarkSync = void 0;
const LogService_1 = require("../classes/LogService");
function benchmarkStart(name) {
    LogService_1.LogService.write(`${name}`);
    return Date.now();
}
function benchmarkEnd(startTime) {
    LogService_1.LogService.write(` ( ${Date.now() - startTime} ms )\n`);
}
function benchmarkSync(name, callback) {
    const startTime = benchmarkStart(name);
    callback();
    benchmarkEnd(startTime);
}
exports.benchmarkSync = benchmarkSync;
function benchmarkIfVerbose(name, callback) {
    if (LogService_1.LogService.verbose) {
        benchmarkSync(name, callback);
    }
    else {
        callback();
    }
}
exports.benchmarkIfVerbose = benchmarkIfVerbose;
async function benchmark(name, callback) {
    const startTime = benchmarkStart(name);
    await callback();
    benchmarkEnd(startTime);
}
exports.benchmark = benchmark;
//# sourceMappingURL=benchmark.js.map