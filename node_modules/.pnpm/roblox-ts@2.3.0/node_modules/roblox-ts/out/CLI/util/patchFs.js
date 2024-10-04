"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l, _m, _o, _p, _q, _r;
Object.defineProperty(exports, "__esModule", { value: true });
const fs_extra_1 = __importDefault(require("fs-extra"));
const NOOP = () => { };
const ASYNC_NOOP = async () => { };
(_a = fs_extra_1.default.copy) !== null && _a !== void 0 ? _a : (fs_extra_1.default.copy = ASYNC_NOOP);
(_b = fs_extra_1.default.copySync) !== null && _b !== void 0 ? _b : (fs_extra_1.default.copySync = NOOP);
(_c = fs_extra_1.default.existsSync) !== null && _c !== void 0 ? _c : (fs_extra_1.default.existsSync = () => false);
(_d = fs_extra_1.default.outputFile) !== null && _d !== void 0 ? _d : (fs_extra_1.default.outputFile = ASYNC_NOOP);
(_e = fs_extra_1.default.outputFileSync) !== null && _e !== void 0 ? _e : (fs_extra_1.default.outputFileSync = NOOP);
(_f = fs_extra_1.default.pathExists) !== null && _f !== void 0 ? _f : (fs_extra_1.default.pathExists = async () => false);
(_g = fs_extra_1.default.pathExistsSync) !== null && _g !== void 0 ? _g : (fs_extra_1.default.pathExistsSync = () => false);
(_h = fs_extra_1.default.readdir) !== null && _h !== void 0 ? _h : (fs_extra_1.default.readdir = async () => []);
(_j = fs_extra_1.default.readdirSync) !== null && _j !== void 0 ? _j : (fs_extra_1.default.readdirSync = () => []);
(_k = fs_extra_1.default.readFileSync) !== null && _k !== void 0 ? _k : (fs_extra_1.default.readFileSync = () => Buffer.from(""));
(_l = fs_extra_1.default.readJson) !== null && _l !== void 0 ? _l : (fs_extra_1.default.readJson = ASYNC_NOOP);
(_m = fs_extra_1.default.readJSONSync) !== null && _m !== void 0 ? _m : (fs_extra_1.default.readJSONSync = NOOP);
(_o = fs_extra_1.default.realpathSync) !== null && _o !== void 0 ? _o : (fs_extra_1.default.realpathSync = ((path) => path));
(_p = fs_extra_1.default.removeSync) !== null && _p !== void 0 ? _p : (fs_extra_1.default.removeSync = NOOP);
(_q = fs_extra_1.default.stat) !== null && _q !== void 0 ? _q : (fs_extra_1.default.stat = () => ({}));
(_r = fs_extra_1.default.statSync) !== null && _r !== void 0 ? _r : (fs_extra_1.default.statSync = () => ({}));
//# sourceMappingURL=patchFs.js.map