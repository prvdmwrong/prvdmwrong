"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getConstrainedType = exports.getConstrainedTypeAtLocation = exports.getParserServices = exports.robloxTSSettings = exports.makeRule = void 0;
const experimental_utils_1 = require("@typescript-eslint/experimental-utils");
exports.makeRule = experimental_utils_1.ESLintUtils.RuleCreator(name => {
    return name;
});
const robloxTSSettings = (o) => {
    const settings = {};
    for (const [name, setting] of Object.entries(o)) {
        settings[`roblox-ts/${name}`] = setting;
    }
    return settings;
};
exports.robloxTSSettings = robloxTSSettings;
/**
 * Try to retrieve typescript parser service from context.
 */
function getParserServices(context) {
    const { parserServices } = context;
    if (!parserServices || !parserServices.program || !parserServices.esTreeNodeToTSNodeMap) {
        /**
         * The user needs to have configured "project" in their parserOptions
         * for @typescript-eslint/parser
         */
        throw new Error('You have used a rule which requires parserServices to be generated. You must therefore provide a value for the "parserOptions.project" property for @typescript-eslint/parser.');
    }
    return parserServices;
}
exports.getParserServices = getParserServices;
/**
 * Resolves the given node's type. Will resolve to the type's generic constraint, if it has one.
 */
function getConstrainedTypeAtLocation(checker, node) {
    const nodeType = checker.getTypeAtLocation(node);
    return checker.getBaseConstraintOfType(nodeType) || nodeType;
}
exports.getConstrainedTypeAtLocation = getConstrainedTypeAtLocation;
function getConstrainedType(service, checker, node) {
    return getConstrainedTypeAtLocation(checker, service.esTreeNodeToTSNodeMap.get(node));
}
exports.getConstrainedType = getConstrainedType;
