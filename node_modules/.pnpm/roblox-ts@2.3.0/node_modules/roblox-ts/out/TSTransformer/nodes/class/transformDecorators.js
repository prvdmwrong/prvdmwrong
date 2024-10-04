"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformDecorators = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const assert_1 = require("../../../Shared/util/assert");
const transformExpression_1 = require("../expressions/transformExpression");
const transformPropertyName_1 = require("../transformPropertyName");
const convertToIndexableExpression_1 = require("../../util/convertToIndexableExpression");
const typescript_1 = __importDefault(require("typescript"));
function transformMemberDecorators(state, node, callback) {
    const result = luau_ast_1.default.list.make();
    const finalizers = luau_ast_1.default.list.make();
    const decorators = typescript_1.default.getDecorators(node);
    const multipleDecorators = decorators !== undefined && decorators.length > 1;
    const name = node.name;
    if (!name || typescript_1.default.isPrivateIdentifier(name))
        return result;
    for (const decorator of decorators !== null && decorators !== void 0 ? decorators : []) {
        let [expression, prereqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, decorator.expression));
        luau_ast_1.default.list.pushList(result, prereqs);
        if (multipleDecorators && !luau_ast_1.default.isSimple(expression)) {
            const tempId = luau_ast_1.default.tempId("decorator");
            luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
                left: tempId,
                right: expression,
            }));
            expression = tempId;
        }
        let key;
        if (typescript_1.default.isMethodDeclaration(node) || typescript_1.default.isPropertyDeclaration(node)) {
            key = state.getClassElementObjectKey(node);
            if (!key) {
                (0, assert_1.assert)(!typescript_1.default.isBindingPattern(name));
                const keyPrereqs = state.capturePrereqs(() => (key = (0, transformPropertyName_1.transformPropertyName)(state, name)));
                luau_ast_1.default.list.pushList(result, keyPrereqs);
            }
        }
        luau_ast_1.default.list.unshiftList(finalizers, callback((0, convertToIndexableExpression_1.convertToIndexableExpression)(expression), key));
    }
    luau_ast_1.default.list.pushList(result, finalizers);
    return result;
}
function transformMethodDecorators(state, member, classId) {
    return transformMemberDecorators(state, member, (expression, key) => {
        (0, assert_1.assert)(key);
        const result = luau_ast_1.default.list.make();
        const descriptorId = luau_ast_1.default.tempId("descriptor");
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: descriptorId,
            right: luau_ast_1.default.call(expression, [
                classId,
                key,
                luau_ast_1.default.map([
                    [
                        luau_ast_1.default.string("value"),
                        luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                            expression: classId,
                            index: key,
                        }),
                    ],
                ]),
            ]),
        }));
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
            condition: descriptorId,
            statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                    expression: classId,
                    index: key,
                }),
                operator: "=",
                right: luau_ast_1.default.property(descriptorId, "value"),
            })),
            elseBody: luau_ast_1.default.list.make(),
        }));
        return result;
    });
}
function transformPropertyDecorators(state, member, classId) {
    return transformMemberDecorators(state, member, (expression, key) => {
        (0, assert_1.assert)(key);
        return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
            expression: luau_ast_1.default.call(expression, [classId, key]),
        }));
    });
}
function transformParameterDecorators(state, member, classId) {
    const result = luau_ast_1.default.list.make();
    for (let i = 0; i < member.parameters.length; i++) {
        const parameter = member.parameters[i];
        const name = parameter.name;
        if (typescript_1.default.isIdentifier(name)) {
            luau_ast_1.default.list.pushList(result, transformMemberDecorators(state, parameter, expression => luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
                expression: luau_ast_1.default.call(expression, [classId, luau_ast_1.default.string(name.text), luau_ast_1.default.number(i)]),
            }))));
        }
    }
    return result;
}
function transformClassDecorators(state, node, classId) {
    return transformMemberDecorators(state, node, expression => luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: classId,
        operator: "=",
        right: luau_ast_1.default.binary(luau_ast_1.default.call(expression, [classId]), "or", classId),
    })));
}
function transformDecorators(state, node, classId) {
    const result = luau_ast_1.default.list.make();
    for (const member of node.members) {
        if (!typescript_1.default.getSelectedSyntacticModifierFlags(member, typescript_1.default.ModifierFlags.Static)) {
            if (typescript_1.default.isMethodDeclaration(member)) {
                luau_ast_1.default.list.pushList(result, transformMethodDecorators(state, member, classId));
                luau_ast_1.default.list.pushList(result, transformParameterDecorators(state, member, classId));
            }
            else if (typescript_1.default.isPropertyDeclaration(member)) {
                luau_ast_1.default.list.pushList(result, transformPropertyDecorators(state, member, classId));
            }
        }
    }
    for (const member of node.members) {
        if (!!typescript_1.default.getSelectedSyntacticModifierFlags(member, typescript_1.default.ModifierFlags.Static)) {
            if (typescript_1.default.isMethodDeclaration(member)) {
                luau_ast_1.default.list.pushList(result, transformMethodDecorators(state, member, classId));
                luau_ast_1.default.list.pushList(result, transformParameterDecorators(state, member, classId));
            }
            else if (typescript_1.default.isPropertyDeclaration(member)) {
                luau_ast_1.default.list.pushList(result, transformPropertyDecorators(state, member, classId));
            }
        }
    }
    for (const member of node.members) {
        if (typescript_1.default.isConstructorDeclaration(member)) {
            luau_ast_1.default.list.pushList(result, transformParameterDecorators(state, member, classId));
        }
    }
    luau_ast_1.default.list.pushList(result, transformClassDecorators(state, node, classId));
    return result;
}
exports.transformDecorators = transformDecorators;
//# sourceMappingURL=transformDecorators.js.map