/// <reference no-default-lib="true"/>
/// <reference types="@rbxts/types"/>

interface Symbol {
	/**
	 * **DO NOT USE!**
	 *
	 * This field exists to force TypeScript to recognize this as a nominal type
	 * @hidden
	 * @deprecated
	 */
	readonly _nominal_Symbol: unique symbol;
}

interface SymbolConstructor {
	readonly iterator: symbol;
	readonly asyncIterator: symbol;
}
declare const Symbol: SymbolConstructor;
