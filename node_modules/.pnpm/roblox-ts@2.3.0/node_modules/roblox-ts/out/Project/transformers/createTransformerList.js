"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createTransformerList = exports.flattenIntoTransformers = void 0;
const resolve_1 = __importDefault(require("resolve"));
const diagnostics_1 = require("../../Shared/diagnostics");
const DiagnosticService_1 = require("../../TSTransformer/classes/DiagnosticService");
const typescript_1 = __importDefault(require("typescript"));
function getTransformerFromFactory(factory, config, program) {
    const { after, afterDeclarations, type, ...manualConfig } = config;
    let transformer;
    switch (type) {
        case undefined:
        case "program":
            transformer = factory(program, manualConfig, { ts: typescript_1.default });
            break;
        case "checker":
            transformer = factory(program.getTypeChecker(), manualConfig);
            break;
        case "compilerOptions":
            transformer = factory(program.getCompilerOptions(), manualConfig);
            break;
        case "config":
            transformer = factory(manualConfig);
            break;
        case "raw":
            transformer = (ctx) => factory(ctx, program, manualConfig);
            break;
        default:
            return undefined;
    }
    if (typeof transformer === "function") {
        if (after) {
            return { after: transformer };
        }
        else if (afterDeclarations) {
            return { afterDeclarations: transformer };
        }
        return { before: transformer };
    }
    return transformer;
}
function flattenIntoTransformers(transformers) {
    const result = [];
    result.push(...transformers.after, ...transformers.before, ...transformers.afterDeclarations);
    return result;
}
exports.flattenIntoTransformers = flattenIntoTransformers;
function createTransformerList(program, configs, baseDir) {
    var _a, _b, _c, _d;
    const transforms = {
        before: [],
        after: [],
        afterDeclarations: [],
    };
    for (const config of configs) {
        if (!config.transform)
            continue;
        try {
            const modulePath = resolve_1.default.sync(config.transform, { basedir: baseDir });
            const commonjsModule = require(modulePath);
            const factoryModule = typeof commonjsModule === "function" ? { default: commonjsModule } : commonjsModule;
            const factory = factoryModule[(_a = config.import) !== null && _a !== void 0 ? _a : "default"];
            if (!factory || typeof factory !== "function")
                throw new Error("factory not a function");
            const transformer = getTransformerFromFactory(factory, config, program);
            if (transformer) {
                if (transformer.afterDeclarations) {
                    (_b = transforms.afterDeclarations) === null || _b === void 0 ? void 0 : _b.push(transformer.afterDeclarations);
                }
                if (transformer.after) {
                    (_c = transforms.after) === null || _c === void 0 ? void 0 : _c.push(transformer.after);
                }
                if (transformer.before) {
                    (_d = transforms.before) === null || _d === void 0 ? void 0 : _d.push(transformer.before);
                }
            }
        }
        catch (err) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.warnings.transformerNotFound(config.transform, err));
        }
    }
    return transforms;
}
exports.createTransformerList = createTransformerList;
//# sourceMappingURL=createTransformerList.js.map