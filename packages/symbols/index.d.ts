declare namespace symbols {
	// export type Symbol<T extends string> = T & {
	// 	readonly type: "Symbol";
	// 	readonly name: T;
	// };
	export type Symbol<T extends string> = T;

	export function symbol<T extends string>(name: T): Symbol<T>;
}

export = symbols;
export as namespace symbols;
