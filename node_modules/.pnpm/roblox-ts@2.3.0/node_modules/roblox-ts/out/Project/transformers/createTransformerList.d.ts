import { TransformerPluginConfig } from "../../Shared/types";
import ts from "typescript";
export declare function flattenIntoTransformers(transformers: ts.CustomTransformers): Array<ts.TransformerFactory<ts.SourceFile | ts.Bundle>>;
export declare function createTransformerList(program: ts.Program, configs: Array<TransformerPluginConfig>, baseDir: string): ts.CustomTransformers;
