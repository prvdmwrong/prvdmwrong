/// <reference no-default-lib="true"/>
/// <reference types="@rbxts/types"/>

// prettier crashes with `intrinsic` keyword

/** Convert string literal type to uppercase */
type Uppercase<S extends string> = intrinsic;

/** Convert string literal type to lowercase */
type Lowercase<S extends string> = intrinsic;

/** Convert first character of string literal type to uppercase */
type Capitalize<S extends string> = intrinsic;

/** Convert first character of string literal type to lowercase */
type Uncapitalize<S extends string> = intrinsic;
