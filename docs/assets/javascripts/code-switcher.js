try {
	const code_lang = document.getElementById("code-lang")

	const luau = []
	const rbxts = []

	const existing_code_lang = localStorage.getItem("prvdmwrong/code-lang")
	if (!existing_code_lang) {
		localStorage.setItem("prvdmwrong/code-lang", "luau")
	} else {
		code_lang.value = existing_code_lang
	}

	function populateStorage() {
		localStorage.setItem("prvdmwrong/code-lang", "luau")
	}

	document.querySelectorAll(".only-luau").forEach((element) => luau.push(element))
	document.querySelectorAll(".only-rbxts").forEach((element) => rbxts.push(element))

	function toggle_lang(elements, should_show) {
		if (should_show) {
			for (const element of elements) {
				element.classList.remove("pmwdoc-code-hidden")
			}
		} else {
			for (const element of elements) {
				element.classList.add("pmwdoc-code-hidden")
			}
		}
	}

	function change_lang() {
		const current_lang = code_lang.value

		// You would think I should be able to iter names by key
		// but for fucks sake mkdocs minifies these javascripts
		console.log(luau, rbxts)
		toggle_lang(luau, current_lang === "luau")
		toggle_lang(rbxts, current_lang === "rbxts")
		localStorage.setItem("prvdmwrong/code-lang", current_lang)
	}

	change_lang()
	code_lang.onchange = change_lang
} catch (err) {
	alert("Cannot instantiate code language switcher; " + err)
}
