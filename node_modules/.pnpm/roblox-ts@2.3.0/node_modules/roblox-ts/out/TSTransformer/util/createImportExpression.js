"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createImportExpression = exports.getImportParts = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const rojo_resolver_1 = require("@roblox-ts/rojo-resolver");
const path_1 = __importDefault(require("path"));
const constants_1 = require("../../Shared/constants");
const diagnostics_1 = require("../../Shared/diagnostics");
const assert_1 = require("../../Shared/util/assert");
const getCanonicalFileName_1 = require("../../Shared/util/getCanonicalFileName");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const createGetService_1 = require("./createGetService");
const expressionChain_1 = require("./expressionChain");
const getSourceFileFromModuleSpecifier_1 = require("./getSourceFileFromModuleSpecifier");
const typescript_1 = __importDefault(require("typescript"));
function getAbsoluteImport(moduleRbxPath) {
    const pathExpressions = new Array();
    const serviceName = moduleRbxPath[0];
    (0, assert_1.assert)(serviceName);
    pathExpressions.push((0, createGetService_1.createGetService)(serviceName));
    for (let i = 1; i < moduleRbxPath.length; i++) {
        pathExpressions.push(luau_ast_1.default.string(moduleRbxPath[i]));
    }
    return pathExpressions;
}
function getRelativeImport(sourceRbxPath, moduleRbxPath) {
    const relativePath = rojo_resolver_1.RojoResolver.relative(sourceRbxPath, moduleRbxPath);
    const path = new Array();
    let i = 0;
    while (relativePath[i] === rojo_resolver_1.RbxPathParent) {
        path.push(constants_1.PARENT_FIELD);
        i++;
    }
    const pathExpressions = [(0, expressionChain_1.propertyAccessExpressionChain)(luau_ast_1.default.globals.script, path)];
    for (; i < relativePath.length; i++) {
        const pathPart = relativePath[i];
        (0, assert_1.assert)(typeof pathPart === "string");
        pathExpressions.push(luau_ast_1.default.string(pathPart));
    }
    return pathExpressions;
}
function validateModule(state, scope) {
    const scopedModules = path_1.default.join(state.data.nodeModulesPath, scope);
    if (state.compilerOptions.typeRoots) {
        for (const typeRoot of state.compilerOptions.typeRoots) {
            if (path_1.default.normalize(scopedModules) === path_1.default.normalize(typeRoot)) {
                return true;
            }
        }
    }
    return false;
}
function findRelativeRbxPath(moduleOutPath, pkgRojoResolvers) {
    for (const pkgRojoResolver of pkgRojoResolvers) {
        const relativeRbxPath = pkgRojoResolver.getRbxPathFromFilePath(moduleOutPath);
        if (relativeRbxPath) {
            return relativeRbxPath;
        }
    }
}
function getNodeModulesImportParts(state, sourceFile, moduleSpecifier, moduleOutPath) {
    const moduleScope = path_1.default.relative(state.data.nodeModulesPath, moduleOutPath).split(path_1.default.sep)[0];
    (0, assert_1.assert)(moduleScope);
    if (!moduleScope.startsWith("@")) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noUnscopedModule(moduleSpecifier));
        return [luau_ast_1.default.none()];
    }
    if (!validateModule(state, moduleScope)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noInvalidModule(moduleSpecifier));
        return [luau_ast_1.default.none()];
    }
    if (state.projectType === constants_1.ProjectType.Package) {
        const relativeRbxPath = findRelativeRbxPath(moduleOutPath, state.pkgRojoResolvers);
        if (!relativeRbxPath) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noRojoData(moduleSpecifier, path_1.default.relative(state.data.projectPath, moduleOutPath), true));
            return [luau_ast_1.default.none()];
        }
        const moduleName = relativeRbxPath[0];
        (0, assert_1.assert)(moduleName);
        return [
            (0, expressionChain_1.propertyAccessExpressionChain)(luau_ast_1.default.call(state.TS(moduleSpecifier.parent, "getModule"), [
                luau_ast_1.default.globals.script,
                luau_ast_1.default.string(moduleScope),
                luau_ast_1.default.string(moduleName),
            ]), relativeRbxPath.slice(1)),
        ];
    }
    else {
        const moduleRbxPath = state.rojoResolver.getRbxPathFromFilePath(moduleOutPath);
        if (!moduleRbxPath) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noRojoData(moduleSpecifier, path_1.default.relative(state.data.projectPath, moduleOutPath), true));
            return [luau_ast_1.default.none()];
        }
        const indexOfScope = moduleRbxPath.indexOf(moduleScope);
        if (indexOfScope === -1 || moduleRbxPath[indexOfScope - 1] !== constants_1.NODE_MODULES) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noPackageImportWithoutScope(moduleSpecifier, path_1.default.relative(state.data.projectPath, moduleOutPath), moduleRbxPath));
            return [luau_ast_1.default.none()];
        }
        return getProjectImportParts(state, sourceFile, moduleSpecifier, moduleOutPath, moduleRbxPath);
    }
}
function getProjectImportParts(state, sourceFile, moduleSpecifier, moduleOutPath, moduleRbxPath) {
    const moduleRbxType = state.rojoResolver.getRbxTypeFromFilePath(moduleOutPath);
    if (moduleRbxType === rojo_resolver_1.RbxType.Script || moduleRbxType === rojo_resolver_1.RbxType.LocalScript) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noNonModuleImport(moduleSpecifier));
        return [luau_ast_1.default.none()];
    }
    const sourceOutPath = state.pathTranslator.getOutputPath(sourceFile.fileName);
    const sourceRbxPath = state.rojoResolver.getRbxPathFromFilePath(sourceOutPath);
    if (!sourceRbxPath) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noRojoData(sourceFile, path_1.default.relative(state.data.projectPath, sourceOutPath), false));
        return [luau_ast_1.default.none()];
    }
    if (state.projectType === constants_1.ProjectType.Game) {
        if (!typescript_1.default.isImportCall(moduleSpecifier.parent) &&
            state.rojoResolver.getNetworkType(moduleRbxPath) === rojo_resolver_1.NetworkType.Server &&
            state.rojoResolver.getNetworkType(sourceRbxPath) !== rojo_resolver_1.NetworkType.Server) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noServerImport(moduleSpecifier));
            return [luau_ast_1.default.none()];
        }
        const fileRelation = state.rojoResolver.getFileRelation(sourceRbxPath, moduleRbxPath);
        if (fileRelation === rojo_resolver_1.FileRelation.OutToOut || fileRelation === rojo_resolver_1.FileRelation.InToOut) {
            return getAbsoluteImport(moduleRbxPath);
        }
        else if (fileRelation === rojo_resolver_1.FileRelation.InToIn) {
            return getRelativeImport(sourceRbxPath, moduleRbxPath);
        }
        else {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noIsolatedImport(moduleSpecifier));
            return [luau_ast_1.default.none()];
        }
    }
    else {
        return getRelativeImport(sourceRbxPath, moduleRbxPath);
    }
}
function getImportParts(state, sourceFile, moduleSpecifier) {
    var _a;
    const moduleFile = (0, getSourceFileFromModuleSpecifier_1.getSourceFileFromModuleSpecifier)(state, moduleSpecifier);
    if (!moduleFile) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noModuleSpecifierFile(moduleSpecifier));
        return [luau_ast_1.default.none()];
    }
    const virtualPath = state.guessVirtualPath(moduleFile.fileName);
    if (typescript_1.default.isInsideNodeModules(virtualPath)) {
        const moduleOutPath = state.pathTranslator.getImportPath((_a = state.nodeModulesPathMapping.get((0, getCanonicalFileName_1.getCanonicalFileName)(path_1.default.normalize(virtualPath)))) !== null && _a !== void 0 ? _a : virtualPath, true);
        return getNodeModulesImportParts(state, sourceFile, moduleSpecifier, moduleOutPath);
    }
    else {
        const moduleOutPath = state.pathTranslator.getImportPath(virtualPath);
        const moduleRbxPath = state.rojoResolver.getRbxPathFromFilePath(moduleOutPath);
        if (!moduleRbxPath) {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noRojoData(moduleSpecifier, path_1.default.relative(state.data.projectPath, moduleOutPath), false));
            return [luau_ast_1.default.none()];
        }
        return getProjectImportParts(state, sourceFile, moduleSpecifier, moduleOutPath, moduleRbxPath);
    }
}
exports.getImportParts = getImportParts;
function createImportExpression(state, sourceFile, moduleSpecifier) {
    const parts = getImportParts(state, sourceFile, moduleSpecifier);
    parts.unshift(luau_ast_1.default.globals.script);
    return luau_ast_1.default.call(state.TS(moduleSpecifier.parent, "import"), parts);
}
exports.createImportExpression = createImportExpression;
//# sourceMappingURL=createImportExpression.js.map