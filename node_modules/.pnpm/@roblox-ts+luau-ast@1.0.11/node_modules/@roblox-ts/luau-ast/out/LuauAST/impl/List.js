"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.list = void 0;
const LuauAST_1 = __importDefault(require(".."));
const assert_1 = require("../util/assert");
const LIST_MARKER = Symbol("List");
var list;
(function (list_1) {
    function makeNode(value) {
        (0, assert_1.assert)(LuauAST_1.default.isNode(value));
        return { value };
    }
    list_1.makeNode = makeNode;
    function make(...values) {
        (0, assert_1.assert)(values.every(node => LuauAST_1.default.isNode(node)), "Not all List values were a luau.Node");
        if (values.length > 0) {
            const head = LuauAST_1.default.list.makeNode(values[0]);
            let tail = head;
            for (let i = 1; i < values.length; i++) {
                const node = LuauAST_1.default.list.makeNode(values[i]);
                tail.next = node;
                node.prev = tail;
                tail = node;
            }
            return { [LIST_MARKER]: true, head, tail, readonly: false };
        }
        else {
            return { [LIST_MARKER]: true, readonly: false };
        }
    }
    list_1.make = make;
    function isList(value) {
        return typeof value === "object" && value[LIST_MARKER] === true;
    }
    list_1.isList = isList;
    function clone(list) {
        const newList = LuauAST_1.default.list.make();
        LuauAST_1.default.list.forEach(list, element => {
            LuauAST_1.default.list.push(newList, { ...element });
        });
        return newList;
    }
    list_1.clone = clone;
    function push(list, value) {
        (0, assert_1.assert)(LuauAST_1.default.isNode(value));
        (0, assert_1.assert)(!list.readonly);
        const node = LuauAST_1.default.list.makeNode(value);
        if (list.tail) {
            list.tail.next = node;
            node.prev = list.tail;
        }
        else {
            list.head = node;
        }
        list.tail = node;
    }
    list_1.push = push;
    function pushList(list, other) {
        (0, assert_1.assert)(!list.readonly);
        (0, assert_1.assert)(!other.readonly);
        other.readonly = true;
        if (other.head && other.tail) {
            if (list.head && list.tail) {
                list.tail.next = other.head;
                other.head.prev = list.tail;
                list.tail = other.tail;
            }
            else {
                list.head = other.head;
                list.tail = other.tail;
            }
        }
    }
    list_1.pushList = pushList;
    function shift(list) {
        (0, assert_1.assert)(!list.readonly);
        if (list.head) {
            const head = list.head;
            if (head.next) {
                list.head = head.next;
                head.next.prev = undefined;
            }
            else {
                list.tail = undefined;
                list.head = undefined;
            }
            return head.value;
        }
    }
    list_1.shift = shift;
    function unshift(list, value) {
        (0, assert_1.assert)(LuauAST_1.default.isNode(value));
        (0, assert_1.assert)(!list.readonly);
        const node = LuauAST_1.default.list.makeNode(value);
        if (list.head) {
            list.head.prev = node;
            node.next = list.head;
        }
        else {
            list.tail = node;
        }
        list.head = node;
    }
    list_1.unshift = unshift;
    function unshiftList(list, other) {
        (0, assert_1.assert)(!list.readonly);
        (0, assert_1.assert)(!other.readonly);
        other.readonly = true;
        if (other.head && other.tail) {
            if (list.head && list.tail) {
                list.head.prev = other.tail;
                other.tail.next = list.head;
                list.head = other.head;
            }
            else {
                list.head = other.head;
                list.tail = other.tail;
            }
        }
    }
    list_1.unshiftList = unshiftList;
    function isEmpty(list) {
        return list.head === undefined;
    }
    list_1.isEmpty = isEmpty;
    function isNonEmpty(list) {
        return list.head !== undefined;
    }
    list_1.isNonEmpty = isNonEmpty;
    function forEach(list, callback) {
        let node = list.head;
        while (node) {
            callback(node.value);
            node = node.next;
        }
    }
    list_1.forEach = forEach;
    function forEachListNode(list, callback) {
        let node = list.head;
        while (node) {
            callback(node);
            node = node.next;
        }
    }
    list_1.forEachListNode = forEachListNode;
    function mapToArray(list, callback) {
        const result = new Array();
        LuauAST_1.default.list.forEach(list, value => result.push(callback(value)));
        return result;
    }
    list_1.mapToArray = mapToArray;
    function toArray(list) {
        const result = new Array();
        LuauAST_1.default.list.forEach(list, value => result.push(value));
        return result;
    }
    list_1.toArray = toArray;
    function every(list, callback) {
        let node = list.head;
        while (node) {
            if (!callback(node.value)) {
                return false;
            }
            node = node.next;
        }
        return true;
    }
    list_1.every = every;
    function some(list, callback) {
        let node = list.head;
        while (node) {
            if (callback(node.value)) {
                return true;
            }
            node = node.next;
        }
        return false;
    }
    list_1.some = some;
    function size(list) {
        let size = 0;
        let node = list.head;
        while (node) {
            size++;
            node = node.next;
        }
        return size;
    }
    list_1.size = size;
})(list || (exports.list = list = {}));
//# sourceMappingURL=List.js.map