"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.copyItem = void 0;
const fs_extra_1 = __importDefault(require("fs-extra"));
const isCompilableFile_1 = require("../util/isCompilableFile");
const constants_1 = require("../../Shared/constants");
function copyItem(data, pathTranslator, item) {
    fs_extra_1.default.copySync(item, pathTranslator.getOutputPath(item), {
        filter: (src, dest) => {
            if (data.projectOptions.writeOnlyChanged &&
                fs_extra_1.default.pathExistsSync(dest) &&
                !fs_extra_1.default.lstatSync(src).isDirectory() &&
                fs_extra_1.default.readFileSync(src).toString() === fs_extra_1.default.readFileSync(dest).toString()) {
                return false;
            }
            if (src.endsWith(constants_1.DTS_EXT)) {
                return pathTranslator.declaration;
            }
            return !(0, isCompilableFile_1.isCompilableFile)(src);
        },
        dereference: true,
    });
}
exports.copyItem = copyItem;
//# sourceMappingURL=copyItem.js.map