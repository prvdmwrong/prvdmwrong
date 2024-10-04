"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.noNamespaceMerging = exports.noNamespaceMergingName = void 0;
const typescript_1 = __importDefault(require("typescript"));
const rules_1 = require("../util/rules");
function isDeclarationOfNamespace(declaration) {
    if (typescript_1.default.isModuleDeclaration(declaration) && typescript_1.default.isInstantiatedModule(declaration, false)) {
        return true;
    }
    else if (typescript_1.default.isFunctionDeclaration(declaration) && declaration.body) {
        return true;
    }
    return false;
}
function hasMultipleInstantiations(symbol) {
    var _a;
    let amtValueDeclarations = 0;
    for (const declaration of (_a = symbol.declarations) !== null && _a !== void 0 ? _a : []) {
        if (isDeclarationOfNamespace(declaration)) {
            amtValueDeclarations++;
            if (amtValueDeclarations > 1) {
                return true;
            }
        }
    }
    return false;
}
exports.noNamespaceMergingName = "no-namespace-merging";
exports.noNamespaceMerging = (0, rules_1.makeRule)({
    name: exports.noNamespaceMergingName,
    meta: {
        type: "problem",
        docs: {
            description: "Bans namespace declaration merging",
            recommended: "error",
            requiresTypeChecking: true,
        },
        messages: {
            namespaceMergingViolation: "Namespace merging is not supported!",
        },
        schema: [],
    },
    defaultOptions: [],
    create(context) {
        const service = (0, rules_1.getParserServices)(context);
        const checker = service.program.getTypeChecker();
        return {
            TSModuleDeclaration(node) {
                const tsNode = service.esTreeNodeToTSNodeMap.get(node);
                if (typescript_1.default.isInstantiatedModule(tsNode, false)) {
                    const symbol = checker.getSymbolAtLocation(tsNode.name);
                    if (symbol && hasMultipleInstantiations(symbol)) {
                        context.report({
                            node: node.id,
                            messageId: "namespaceMergingViolation",
                        });
                    }
                }
            },
        };
    },
});
