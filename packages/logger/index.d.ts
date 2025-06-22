declare namespace Logger {
	export interface Error {
		type: "Error";
		raw: string;
		message: string;
		trace: string;
	}

	interface LogProps {
		template: string;
		error?: Error;
		trace?: string;
	}

	export type Log = LogProps & unknown[];

	interface LoggerProps {
		print(props: Log): void;
		warn(props: Log): void;
		error(props: Log): void;
		fatalError(props: Log): never;
	}

	export type Logger<Templates extends Record<string, string>> = LoggerProps & Templates;

	export function create<Templates extends Record<string, string>>(
		label: string,
		errorInfoUrl: string | undefined,
		templates: Templates
	): Logger<Templates>;

	export function formatLog<Templates extends Record<string, string>>(
		logger: Logger<Templates>,
		log: Log,
		errorInfoUrl?: string
	): string;

	export function parseError(err: string): Error;

	export const allowWebLinks: boolean;
	export function standardErrorInfoUrl(label: string): string;
}

export = Logger;
export as namespace Logger;
