"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getPluginConfigs = void 0;
const path_1 = __importDefault(require("path"));
const ProjectError_1 = require("../../Shared/errors/ProjectError");
const typescript_1 = __importDefault(require("typescript"));
function getPluginConfigs(tsConfigPath) {
    var _a;
    const configFile = typescript_1.default.readConfigFile(tsConfigPath, typescript_1.default.sys.readFile);
    if (configFile.error) {
        throw new ProjectError_1.ProjectError(configFile.error.messageText.toString());
    }
    const pluginConfigs = new Array();
    const config = configFile.config;
    const plugins = (_a = config.compilerOptions) === null || _a === void 0 ? void 0 : _a.plugins;
    if (plugins && Array.isArray(plugins)) {
        for (const pluginConfig of plugins) {
            if (pluginConfig.transform && typeof pluginConfig.transform === "string") {
                pluginConfigs.push(pluginConfig);
            }
        }
    }
    if (config.extends) {
        const extendedPath = require.resolve(config.extends, {
            paths: [path_1.default.dirname(tsConfigPath)],
        });
        pluginConfigs.push(...getPluginConfigs(extendedPath));
    }
    return pluginConfigs;
}
exports.getPluginConfigs = getPluginConfigs;
//# sourceMappingURL=getPluginConfigs.js.map