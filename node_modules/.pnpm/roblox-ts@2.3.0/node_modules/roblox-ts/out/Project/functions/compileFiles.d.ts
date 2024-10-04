import { PathTranslator } from "@roblox-ts/path-translator";
import { ProjectData } from "../../Shared/types";
import ts from "typescript";
export declare function compileFiles(program: ts.Program, data: ProjectData, pathTranslator: PathTranslator, sourceFiles: Array<ts.SourceFile>): ts.EmitResult;
