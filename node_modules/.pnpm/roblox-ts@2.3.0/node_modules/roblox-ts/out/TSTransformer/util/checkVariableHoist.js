"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkVariableHoist = void 0;
const getOrSetDefault_1 = require("../../Shared/util/getOrSetDefault");
const traversal_1 = require("./traversal");
const typescript_1 = __importDefault(require("typescript"));
function checkVariableHoist(state, node, symbol) {
    if (state.isHoisted.get(symbol) !== undefined) {
        return;
    }
    const statement = (0, traversal_1.getAncestor)(node, typescript_1.default.isStatement);
    if (!statement) {
        return;
    }
    const caseClause = statement.parent;
    if (!typescript_1.default.isCaseClause(caseClause)) {
        return;
    }
    const caseBlock = caseClause.parent;
    const isUsedOutsideOfCaseClause = typescript_1.default.FindAllReferences.Core.eachSymbolReferenceInFile(node, state.typeChecker, node.getSourceFile(), token => {
        if (!(0, traversal_1.isAncestorOf)(caseClause, token)) {
            return true;
        }
    }, caseBlock) === true;
    if (isUsedOutsideOfCaseClause) {
        (0, getOrSetDefault_1.getOrSetDefault)(state.hoistsByStatement, statement.parent, () => new Array()).push(node);
        state.isHoisted.set(symbol, true);
    }
}
exports.checkVariableHoist = checkVariableHoist;
//# sourceMappingURL=checkVariableHoist.js.map