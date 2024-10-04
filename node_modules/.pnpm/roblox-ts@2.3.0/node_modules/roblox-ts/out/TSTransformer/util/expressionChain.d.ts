import luau from "@roblox-ts/luau-ast";
export declare function binaryExpressionChain(expressions: Array<luau.Expression>, operator: luau.BinaryOperator): luau.Expression;
export declare function propertyAccessExpressionChain(expression: luau.Expression, names: Array<string>): luau.IndexableExpression;
