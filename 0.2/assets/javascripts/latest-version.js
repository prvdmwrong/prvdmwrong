try {
	const version = document.querySelector("#pmwdoc-version")
	if (version) {
		fetch("https://registry.npmjs.org/@prvdmwrong/core/")
			.then((response) => response.json())
			.then((data) => (version.innerHTML = data["dist-tags"].latest ?? data.error))
	}
} catch (err) {
	alert("Cannot instantiate latest version; " + err)
	console.error(err)
}
