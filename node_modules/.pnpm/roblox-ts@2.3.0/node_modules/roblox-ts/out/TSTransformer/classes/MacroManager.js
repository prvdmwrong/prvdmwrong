"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MacroManager = exports.NOMINAL_LUA_TUPLE_NAME = exports.SYMBOL_NAMES = void 0;
const ProjectError_1 = require("../../Shared/errors/ProjectError");
const assert_1 = require("../../Shared/util/assert");
const callMacros_1 = require("../macros/callMacros");
const constructorMacros_1 = require("../macros/constructorMacros");
const identifierMacros_1 = require("../macros/identifierMacros");
const propertyCallMacros_1 = require("../macros/propertyCallMacros");
const traversal_1 = require("../util/traversal");
const typescript_1 = __importDefault(require("typescript"));
function getType(typeChecker, node) {
    return typeChecker.getTypeAtLocation((0, traversal_1.skipUpwards)(node));
}
const TYPES_NOTICE = "\nYou may need to update your @rbxts/compiler-types!";
exports.SYMBOL_NAMES = {
    globalThis: "globalThis",
    ArrayConstructor: "ArrayConstructor",
    SetConstructor: "SetConstructor",
    MapConstructor: "MapConstructor",
    WeakSetConstructor: "WeakSetConstructor",
    WeakMapConstructor: "WeakMapConstructor",
    ReadonlyMapConstructor: "ReadonlyMapConstructor",
    ReadonlySetConstructor: "ReadonlySetConstructor",
    Array: "Array",
    Generator: "Generator",
    IterableFunction: "IterableFunction",
    LuaTuple: "LuaTuple",
    Map: "Map",
    Object: "Object",
    ReadonlyArray: "ReadonlyArray",
    ReadonlyMap: "ReadonlyMap",
    ReadonlySet: "ReadonlySet",
    ReadVoxelsArray: "ReadVoxelsArray",
    Set: "Set",
    String: "String",
    TemplateStringsArray: "TemplateStringsArray",
    WeakMap: "WeakMap",
    WeakSet: "WeakSet",
    Iterable: "Iterable",
    $range: "$range",
    $tuple: "$tuple",
};
exports.NOMINAL_LUA_TUPLE_NAME = "_nominal_LuaTuple";
const MACRO_ONLY_CLASSES = new Set([
    exports.SYMBOL_NAMES.ReadonlyArray,
    exports.SYMBOL_NAMES.Array,
    exports.SYMBOL_NAMES.ReadonlyMap,
    exports.SYMBOL_NAMES.WeakMap,
    exports.SYMBOL_NAMES.Map,
    exports.SYMBOL_NAMES.ReadonlySet,
    exports.SYMBOL_NAMES.WeakSet,
    exports.SYMBOL_NAMES.Set,
    exports.SYMBOL_NAMES.String,
]);
function getFirstDeclarationOrThrow(symbol, check) {
    var _a;
    for (const declaration of (_a = symbol.declarations) !== null && _a !== void 0 ? _a : []) {
        if (check(declaration)) {
            return declaration;
        }
    }
    throw new ProjectError_1.ProjectError("");
}
function getGlobalSymbolByNameOrThrow(typeChecker, name, meaning) {
    const symbol = typeChecker.resolveName(name, undefined, meaning, false);
    if (symbol) {
        return symbol;
    }
    throw new ProjectError_1.ProjectError(`MacroManager could not find symbol for ${name}` + TYPES_NOTICE);
}
function getConstructorSymbol(node) {
    for (const member of node.members) {
        if (typescript_1.default.isConstructSignatureDeclaration(member)) {
            (0, assert_1.assert)(member.symbol);
            return member.symbol;
        }
    }
    throw new ProjectError_1.ProjectError(`MacroManager could not find constructor for ${node.name.text}` + TYPES_NOTICE);
}
class MacroManager {
    constructor(typeChecker) {
        var _a, _b, _c;
        this.symbols = new Map();
        this.identifierMacros = new Map();
        this.callMacros = new Map();
        this.constructorMacros = new Map();
        this.propertyCallMacros = new Map();
        for (const [name, macro] of Object.entries(identifierMacros_1.IDENTIFIER_MACROS)) {
            const symbol = getGlobalSymbolByNameOrThrow(typeChecker, name, typescript_1.default.SymbolFlags.Variable);
            this.identifierMacros.set(symbol, macro);
        }
        for (const [name, macro] of Object.entries(callMacros_1.CALL_MACROS)) {
            const symbol = getGlobalSymbolByNameOrThrow(typeChecker, name, typescript_1.default.SymbolFlags.Function);
            this.callMacros.set(symbol, macro);
        }
        for (const [className, macro] of Object.entries(constructorMacros_1.CONSTRUCTOR_MACROS)) {
            const symbol = getGlobalSymbolByNameOrThrow(typeChecker, className, typescript_1.default.SymbolFlags.Interface);
            const interfaceDec = getFirstDeclarationOrThrow(symbol, typescript_1.default.isInterfaceDeclaration);
            const constructSymbol = getConstructorSymbol(interfaceDec);
            this.constructorMacros.set(constructSymbol, macro);
        }
        for (const [className, methods] of Object.entries(propertyCallMacros_1.PROPERTY_CALL_MACROS)) {
            const symbol = getGlobalSymbolByNameOrThrow(typeChecker, className, typescript_1.default.SymbolFlags.Interface);
            const methodMap = new Map();
            for (const declaration of (_a = symbol.declarations) !== null && _a !== void 0 ? _a : []) {
                if (typescript_1.default.isInterfaceDeclaration(declaration)) {
                    for (const member of declaration.members) {
                        if (typescript_1.default.isMethodSignature(member) && typescript_1.default.isIdentifier(member.name)) {
                            const symbol = getType(typeChecker, member).symbol;
                            (0, assert_1.assert)(symbol);
                            methodMap.set(member.name.text, symbol);
                        }
                    }
                }
            }
            for (const [methodName, macro] of Object.entries(methods)) {
                const methodSymbol = methodMap.get(methodName);
                if (!methodSymbol) {
                    throw new ProjectError_1.ProjectError(`MacroManager could not find method for ${className}.${methodName}` + TYPES_NOTICE);
                }
                this.propertyCallMacros.set(methodSymbol, macro);
            }
        }
        for (const symbolName of Object.values(exports.SYMBOL_NAMES)) {
            const symbol = typeChecker.resolveName(symbolName, undefined, typescript_1.default.SymbolFlags.All, false);
            if (symbol) {
                this.symbols.set(symbolName, symbol);
            }
            else {
                throw new ProjectError_1.ProjectError(`MacroManager could not find symbol for ${symbolName}` + TYPES_NOTICE);
            }
        }
        const luaTupleTypeDec = (_c = (_b = this.symbols
            .get(exports.SYMBOL_NAMES.LuaTuple)) === null || _b === void 0 ? void 0 : _b.declarations) === null || _c === void 0 ? void 0 : _c.find(v => typescript_1.default.isTypeAliasDeclaration(v));
        if (luaTupleTypeDec) {
            const nominalLuaTupleSymbol = typeChecker
                .getTypeAtLocation(luaTupleTypeDec)
                .getProperty(exports.NOMINAL_LUA_TUPLE_NAME);
            if (nominalLuaTupleSymbol) {
                this.symbols.set(exports.NOMINAL_LUA_TUPLE_NAME, nominalLuaTupleSymbol);
            }
        }
    }
    getSymbolOrThrow(name) {
        const symbol = this.symbols.get(name);
        (0, assert_1.assert)(symbol);
        return symbol;
    }
    isMacroOnlyClass(symbol) {
        return this.symbols.get(symbol.name) === symbol && MACRO_ONLY_CLASSES.has(symbol.name);
    }
    getIdentifierMacro(symbol) {
        return this.identifierMacros.get(symbol);
    }
    getCallMacro(symbol) {
        return this.callMacros.get(symbol);
    }
    getConstructorMacro(symbol) {
        return this.constructorMacros.get(symbol);
    }
    getPropertyCallMacro(symbol) {
        const macro = this.propertyCallMacros.get(symbol);
        if (!macro &&
            symbol.parent &&
            this.symbols.get(symbol.parent.name) === symbol.parent &&
            this.isMacroOnlyClass(symbol.parent)) {
            (0, assert_1.assert)(false, `Macro ${symbol.parent.name}.${symbol.name}() is not implemented!`);
        }
        return macro;
    }
}
exports.MacroManager = MacroManager;
//# sourceMappingURL=MacroManager.js.map