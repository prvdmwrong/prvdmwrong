"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VirtualFileSystem = exports.pathJoin = exports.PATH_SEP = void 0;
const assert_1 = require("../../Shared/util/assert");
const getOrSetDefault_1 = require("../../Shared/util/getOrSetDefault");
exports.PATH_SEP = "/";
function pathJoin(...parts) {
    let result = parts[0];
    for (let i = 1; i < parts.length; i++) {
        if (!result.endsWith(exports.PATH_SEP)) {
            result += exports.PATH_SEP;
        }
        result += parts[i];
    }
    return result;
}
exports.pathJoin = pathJoin;
class VirtualFileSystem {
    constructor() {
        this.root = {
            name: "",
            children: new Map(),
        };
    }
    getPathParts(filePath) {
        return filePath.split(exports.PATH_SEP).filter(v => v.length > 0);
    }
    writeFile(filePath, content) {
        const pathParts = this.getPathParts(filePath);
        const fileName = pathParts.pop();
        let currentDir = this.root;
        for (const name of pathParts) {
            const child = (0, getOrSetDefault_1.getOrSetDefault)(currentDir.children, name, () => ({
                name,
                children: new Map(),
            }));
            (0, assert_1.assert)("children" in child);
            currentDir = child;
        }
        currentDir.children.set(fileName, {
            name: fileName,
            content,
        });
    }
    get(itemPath) {
        const pathParts = this.getPathParts(itemPath);
        const fileName = pathParts.pop();
        let currentDir = this.root;
        for (const name of pathParts) {
            const child = currentDir.children.get(name);
            if (!child)
                return undefined;
            if (!("children" in child))
                return undefined;
            currentDir = child;
        }
        return currentDir.children.get(fileName);
    }
    readFile(filePath) {
        const item = this.get(filePath);
        if (item && "content" in item) {
            return item.content;
        }
    }
    fileExists(filePath) {
        const item = this.get(filePath);
        return item !== undefined && "content" in item;
    }
    directoryExists(dirPath) {
        const item = this.get(dirPath);
        return item !== undefined && "children" in item;
    }
    getDirectories(dirPath) {
        const result = new Array();
        const item = this.get(dirPath);
        if (item && "children" in item) {
            for (const [name, child] of item.children) {
                if ("children" in child) {
                    result.push(pathJoin(dirPath, name));
                }
            }
        }
        return result;
    }
    getFilePaths() {
        const filePaths = new Array();
        const search = (dir, partialPath = "") => {
            for (const [name, child] of dir.children) {
                if ("children" in child) {
                    search(child, `${partialPath}/${name}`);
                }
                else {
                    filePaths.push(`${partialPath}/${name}`);
                }
            }
        };
        search(this.root);
        return filePaths;
    }
}
exports.VirtualFileSystem = VirtualFileSystem;
//# sourceMappingURL=VirtualFileSystem.js.map