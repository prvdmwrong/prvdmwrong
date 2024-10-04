"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.call = exports.property = exports.unary = exports.binary = exports.mixedTable = exports.map = exports.set = exports.array = exports.comment = exports.id = exports.string = exports.number = exports.bool = exports.nil = exports.none = exports.tempId = exports.create = void 0;
const luau = __importStar(require("../bundle"));
function create(kind, fields) {
    const node = Object.assign({ kind }, fields);
    for (const [key, value] of Object.entries(fields)) {
        if (luau.isNode(value)) {
            if (value.parent) {
                const clone = { ...value };
                clone.parent = node;
                node[key] = clone;
            }
            else {
                value.parent = node;
            }
        }
        else if (luau.list.isList(value)) {
            luau.list.forEachListNode(value, listNode => {
                if (listNode.value.parent) {
                    const clone = { ...listNode.value };
                    clone.parent = node;
                    listNode.value = clone;
                }
                else {
                    listNode.value.parent = node;
                }
            });
        }
    }
    return node;
}
exports.create = create;
let lastTempId = 0;
function tempId(name = "") {
    return luau.create(luau.SyntaxKind.TemporaryIdentifier, { name, id: lastTempId++ });
}
exports.tempId = tempId;
function none() {
    return luau.create(luau.SyntaxKind.None, {});
}
exports.none = none;
function nil() {
    return luau.create(luau.SyntaxKind.NilLiteral, {});
}
exports.nil = nil;
function bool(value) {
    if (value) {
        return luau.create(luau.SyntaxKind.TrueLiteral, {});
    }
    else {
        return luau.create(luau.SyntaxKind.FalseLiteral, {});
    }
}
exports.bool = bool;
function number(value) {
    if (value >= 0) {
        return luau.create(luau.SyntaxKind.NumberLiteral, { value: String(value) });
    }
    else {
        return luau.create(luau.SyntaxKind.UnaryExpression, {
            operator: "-",
            expression: luau.number(Math.abs(value)),
        });
    }
}
exports.number = number;
function string(value) {
    return luau.create(luau.SyntaxKind.StringLiteral, { value });
}
exports.string = string;
function id(name) {
    return luau.create(luau.SyntaxKind.Identifier, { name });
}
exports.id = id;
function comment(text) {
    return luau.create(luau.SyntaxKind.Comment, { text });
}
exports.comment = comment;
function array(members = []) {
    return luau.create(luau.SyntaxKind.Array, {
        members: luau.list.make(...members),
    });
}
exports.array = array;
function set(members = []) {
    return luau.create(luau.SyntaxKind.Set, {
        members: luau.list.make(...members),
    });
}
exports.set = set;
function map(fields = []) {
    return luau.create(luau.SyntaxKind.Map, {
        fields: luau.list.make(...fields.map(([index, value]) => luau.create(luau.SyntaxKind.MapField, { index, value }))),
    });
}
exports.map = map;
function mixedTable(fields = []) {
    return luau.create(luau.SyntaxKind.MixedTable, {
        fields: luau.list.make(...fields.map(field => {
            if (Array.isArray(field)) {
                return luau.create(luau.SyntaxKind.MapField, { index: field[0], value: field[1] });
            }
            else {
                return field;
            }
        })),
    });
}
exports.mixedTable = mixedTable;
function binary(left, operator, right) {
    return luau.create(luau.SyntaxKind.BinaryExpression, { left, operator, right });
}
exports.binary = binary;
function unary(operator, expression) {
    return luau.create(luau.SyntaxKind.UnaryExpression, { operator, expression });
}
exports.unary = unary;
function property(expression, name) {
    return luau.create(luau.SyntaxKind.PropertyAccessExpression, { expression, name });
}
exports.property = property;
function call(expression, args = []) {
    return luau.create(luau.SyntaxKind.CallExpression, {
        expression,
        args: luau.list.make(...args),
    });
}
exports.call = call;
//# sourceMappingURL=create.js.map