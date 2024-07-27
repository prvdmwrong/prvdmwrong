/*
 * Copyright 2024 Team Fireworks
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the “Software”), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

try {
	const headers = []
	document
		.querySelectorAll(".md-main .md-content .md-typeset h2")
		.forEach((element) => {
			headers.push({
				lowercase: element.firstChild.textContent.toLowerCase(),
				element: element,
			})
		})

	const paste_box = document.querySelector("#ompdoc-error-box")
	paste_box.addEventListener("input", () => {
		const matches = headers.filter((header) =>
			paste_box.value.toLowerCase().includes(header.lowercase),
		)

		const match = matches.length == 1 ? matches[0] : null
		if (match != null) {
			let header = matches[0].element
			let y = header.getBoundingClientRect().top - 300
			window.scrollTo({ top: y, left: 0, behavior: "smooth" })
		}
	})
} catch (err) {
	alert("Cannot instantiate error box; " + err)
}
