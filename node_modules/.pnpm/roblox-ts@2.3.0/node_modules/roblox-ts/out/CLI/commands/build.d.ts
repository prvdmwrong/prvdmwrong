import { ProjectOptions } from "../../Shared/types";
import yargs from "yargs";
interface BuildFlags {
    project: string;
}
declare const _default: yargs.CommandModule<{}, BuildFlags & Partial<ProjectOptions>>;
export = _default;
