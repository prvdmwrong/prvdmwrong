return {
	generator = {
		name = "dense",
		column_span = 9999999999,
	},
	bundle = {
		modules_identifier = "__BUNDLE",
		require_mode = {
			sources = {},
		},
	},
	rules = {
		{
			identifier = "__DEV__",
			rule = "inject_global_value",
			value = false,
		},
		"compute_expression",
		"remove_unused_if_branch",
		"remove_unused_while",
		"filter_after_early_return",
		"remove_nil_declaration",
		"remove_empty_do",
		"remove_spaces",
	},
}
