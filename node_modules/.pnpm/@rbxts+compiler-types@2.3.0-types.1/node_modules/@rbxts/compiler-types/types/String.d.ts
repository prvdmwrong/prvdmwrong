/// <reference no-default-lib="true"/>
/// <reference types="@rbxts/types"/>

interface String extends Iterable<string> {
	/**
	 * **DO NOT USE!**
	 *
	 * This field exists to force TypeScript to recognize this as a nominal type
	 * @hidden
	 * @deprecated
	 */
	readonly _nominal_String: unique symbol;

	/** The current number of characters in the string. */
	size(this: string): number;
}
