"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformStatementList = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformStatement_1 = require("./statements/transformStatement");
const createHoistDeclaration_1 = require("../util/createHoistDeclaration");
const typescript_1 = __importDefault(require("typescript"));
function getLastToken(parent, statements) {
    if (statements.length > 0) {
        const lastStatement = statements[statements.length - 1];
        const lastToken = lastStatement.parent.getLastToken();
        if (lastToken && !typescript_1.default.isNodeDescendantOf(lastToken, lastStatement)) {
            return lastToken;
        }
    }
    else if (parent) {
        return parent.getLastToken();
    }
}
function transformStatementList(state, parent, statements, exportInfo) {
    var _a;
    const result = luau_ast_1.default.list.make();
    for (const statement of statements) {
        const [transformedStatements, prereqStatements] = state.capture(() => (0, transformStatement_1.transformStatement)(state, statement));
        if (state.compilerOptions.removeComments !== true) {
            luau_ast_1.default.list.pushList(result, state.getLeadingComments(statement));
        }
        const hoistDeclaration = (0, createHoistDeclaration_1.createHoistDeclaration)(state, statement);
        if (hoistDeclaration) {
            luau_ast_1.default.list.push(result, hoistDeclaration);
        }
        luau_ast_1.default.list.pushList(result, prereqStatements);
        luau_ast_1.default.list.pushList(result, transformedStatements);
        const lastStatement = (_a = transformedStatements.tail) === null || _a === void 0 ? void 0 : _a.value;
        if (lastStatement && luau_ast_1.default.isFinalStatement(lastStatement)) {
            break;
        }
        if (exportInfo) {
            const containerId = exportInfo.id;
            const exportMapping = exportInfo.mapping.get(statement);
            if (exportMapping !== undefined) {
                for (const exportName of exportMapping) {
                    luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                        left: luau_ast_1.default.property(containerId, exportName),
                        operator: "=",
                        right: luau_ast_1.default.id(exportName),
                    }));
                }
            }
        }
    }
    if (state.compilerOptions.removeComments !== true) {
        const lastToken = getLastToken(parent, statements);
        if (lastToken) {
            luau_ast_1.default.list.pushList(result, state.getLeadingComments(lastToken));
        }
    }
    return result;
}
exports.transformStatementList = transformStatementList;
//# sourceMappingURL=transformStatementList.js.map