type Expectation = {
	to: Expectation,
	be: Expectation,
	been: Expectation,
	have: Expectation,
	was: Expectation,
	at: Expectation,
	never: Expectation,

	a: (typeName: string) -> Expectation,
	ok: () -> Expectation,
	equal: (otherValue: any) -> Expectation,
	near: (otherValue: number, limit: number?) -> Expectation,
	throw: (messageSubstring: string?) -> Expectation,
}

declare function FIXME(optionalMessage: string?)
declare function FOCUS()
declare function SKIP()
declare function afterAll(callback: () -> ())
declare function afterEach(callback: () -> ())
declare function beforeAll(callback: () -> ())
declare function beforeEach(callback: () -> ())
declare function describe(phrase: string, callback: () -> ())
declare function describeFOCUS(phrase: string, callback: () -> ())
declare function describeSKIP(phrase: string, callback: () -> ())
declare function fdescribe(phrase: string, callback: () -> ())
declare function xdescribe(phrase: string, callback: () -> ())
declare function expect(value: any): Expectation
declare function it(phrase: string, callback: () -> ())
declare function itFIXME(phrase: string, callback: () -> ())
declare function itFOCUS(phrase: string, callback: () -> ())
declare function itSKIP(phrase: string, callback: () -> ())
declare function fit(phrase: string, callback: () -> ())
declare function xit(phrase: string, callback: () -> ())
