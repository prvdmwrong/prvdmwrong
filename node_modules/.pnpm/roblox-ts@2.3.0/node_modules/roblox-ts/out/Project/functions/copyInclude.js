"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.copyInclude = void 0;
const fs_extra_1 = __importDefault(require("fs-extra"));
const constants_1 = require("../../Shared/constants");
const benchmark_1 = require("../../Shared/util/benchmark");
function copyInclude(data) {
    if (!data.projectOptions.noInclude &&
        data.projectOptions.type !== constants_1.ProjectType.Package &&
        !(data.projectOptions.type === undefined && data.isPackage)) {
        (0, benchmark_1.benchmarkIfVerbose)("copy include files", () => fs_extra_1.default.copySync(constants_1.INCLUDE_PATH, data.projectOptions.includePath, { dereference: true }));
    }
}
exports.copyInclude = copyInclude;
//# sourceMappingURL=copyInclude.js.map