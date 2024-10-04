import { ProjectData } from "../../Shared/types";
import ts from "typescript";
export declare function createProjectProgram(data: ProjectData, host?: ts.CompilerHost): ts.EmitAndSemanticDiagnosticsBuilderProgram;
