"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getTypeArguments = exports.isArrayType = exports.isEmptyStringType = exports.isUndefinedType = exports.isObjectType = exports.isStringType = exports.isNaNType = exports.isNumberLiteralType = exports.isNumberType = exports.isBooleanLiteralType = exports.isBooleanType = exports.isAnyType = exports.isDefinedType = exports.isPossiblyType = exports.isDefinitelyType = exports.getType = void 0;
const typescript_1 = __importDefault(require("typescript"));
const traversal_1 = require("./traversal");
function getType(typeChecker, node) {
    return typeChecker.getTypeAtLocation((0, traversal_1.skipUpwards)(node));
}
exports.getType = getType;
function getRecursiveBaseTypesInner(result, type) {
    var _a;
    for (const baseType of (_a = type.getBaseTypes()) !== null && _a !== void 0 ? _a : []) {
        result.push(baseType);
        if (baseType.isClassOrInterface()) {
            getRecursiveBaseTypesInner(result, baseType);
        }
    }
}
function getRecursiveBaseTypes(type) {
    const result = new Array();
    getRecursiveBaseTypesInner(result, type);
    return result;
}
function isDefinitelyTypeInner(type, callback) {
    if (type.isUnion()) {
        return type.types.every(t => isDefinitelyTypeInner(t, callback));
    }
    else if (type.isIntersection()) {
        return type.types.some(t => isDefinitelyTypeInner(t, callback));
    }
    else {
        if (type.isClassOrInterface() && getRecursiveBaseTypes(type).some(t => isDefinitelyTypeInner(t, callback))) {
            return true;
        }
        return callback(type);
    }
}
function isDefinitelyType(type, callback) {
    var _a;
    return isDefinitelyTypeInner((_a = type.getConstraint()) !== null && _a !== void 0 ? _a : type, callback);
}
exports.isDefinitelyType = isDefinitelyType;
function isPossiblyTypeInner(type, callback) {
    if (type.isUnionOrIntersection()) {
        return type.types.some(t => isPossiblyTypeInner(t, callback));
    }
    else {
        if (type.isClassOrInterface() && getRecursiveBaseTypes(type).some(t => isPossiblyTypeInner(t, callback))) {
            return true;
        }
        // type variable without constraint, any, or unknown
        if (!!(type.flags & (typescript_1.default.TypeFlags.TypeVariable | typescript_1.default.TypeFlags.Any | typescript_1.default.TypeFlags.Unknown))) {
            return true;
        }
        // defined type
        if (isDefinedType(type)) {
            return true;
        }
        return callback(type);
    }
}
function isPossiblyType(type, callback) {
    var _a;
    return isPossiblyTypeInner((_a = type.getConstraint()) !== null && _a !== void 0 ? _a : type, callback);
}
exports.isPossiblyType = isPossiblyType;
function isDefinedType(type) {
    return (type.flags === typescript_1.default.TypeFlags.Object &&
        type.getProperties().length === 0 &&
        type.getCallSignatures().length === 0 &&
        type.getConstructSignatures().length === 0 &&
        type.getNumberIndexType() === undefined &&
        type.getStringIndexType() === undefined);
}
exports.isDefinedType = isDefinedType;
function isAnyType(type) {
    return !!(type.flags & typescript_1.default.TypeFlags.Any);
}
exports.isAnyType = isAnyType;
function isBooleanType(type) {
    return !!(type.flags & (typescript_1.default.TypeFlags.Boolean | typescript_1.default.TypeFlags.BooleanLiteral));
}
exports.isBooleanType = isBooleanType;
function isBooleanLiteralType(typeChecker, type, value) {
    if (!!(type.flags & typescript_1.default.TypeFlags.BooleanLiteral)) {
        const valueType = value ? typeChecker.getTrueType() : typeChecker.getFalseType();
        return type === valueType;
    }
    return isBooleanType(type);
}
exports.isBooleanLiteralType = isBooleanLiteralType;
function isNumberType(type) {
    return !!(type.flags & (typescript_1.default.TypeFlags.Number | typescript_1.default.TypeFlags.NumberLike | typescript_1.default.TypeFlags.NumberLiteral));
}
exports.isNumberType = isNumberType;
function isNumberLiteralType(type, value) {
    if (type.isNumberLiteral()) {
        return type.value === value;
    }
    return isNumberType(type);
}
exports.isNumberLiteralType = isNumberLiteralType;
function isNaNType(type) {
    return isNumberType(type) && !type.isNumberLiteral();
}
exports.isNaNType = isNaNType;
function isStringType(type) {
    return !!(type.flags & (typescript_1.default.TypeFlags.String | typescript_1.default.TypeFlags.StringLike | typescript_1.default.TypeFlags.StringLiteral));
}
exports.isStringType = isStringType;
function isObjectType(type) {
    return !!(type.flags & typescript_1.default.TypeFlags.Object);
}
exports.isObjectType = isObjectType;
function isUndefinedType(type) {
    return !!(type.flags & (typescript_1.default.TypeFlags.Undefined | typescript_1.default.TypeFlags.Void));
}
exports.isUndefinedType = isUndefinedType;
function isEmptyStringType(type) {
    if (type.isStringLiteral()) {
        return type.value === "";
    }
    return isStringType(type);
}
exports.isEmptyStringType = isEmptyStringType;
function isArrayType(checker, type) {
    if (checker.isTupleType(type) || checker.isArrayLikeType(type)) {
        return true;
    }
    if (type.symbol) {
        if (type.symbol.name === "ReadonlyArray" ||
            type.symbol.name === "Array" ||
            type.symbol.name === "ReadVoxelsArray" ||
            type.symbol.name === "TemplateStringsArray") {
            return true;
        }
    }
    return false;
}
exports.isArrayType = isArrayType;
function getTypeArguments(typeChecker, type) {
    var _a;
    return (_a = typeChecker.getTypeArguments(type)) !== null && _a !== void 0 ? _a : [];
}
exports.getTypeArguments = getTypeArguments;
