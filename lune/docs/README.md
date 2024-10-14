# API Reference Generator

## Prerequisites

- `lune` for running the script, prefer to use the [Rokit] toolchain manager
- `moonwave-extractor` to extract Luau documentation
    - Moonwave does not install through [Rokit] on MacOS, please instead install via [Cargo]:

        ```Bash
        cargo install moonwave
        ```

- `mkdocs-material` for the baseline documentation theme, installed via `pip install mkdocs-material`
- `mkdocs` for previewing the documentation, installed via `pip install mkdocs`

[Cargo]: https://crates.io/
[Rokit]: https://github.com/rojo-rbx/rokit

## Usage

- Run `lune run docs` to generate fresh API reference documentation
- Visit <http://127.0.0.1:8000/prvdmwrong/api-reference> to preview it

Template markdown files can be found in `lune/docs/templates`, though actual
generation logic is written in `lune/docs/init.luau`. In the future Prvd 'M
Wrong might translate [Jinja] to Luau and use that.

Note that new/removed APIs need to be added or removed from the documentation
`mkdocs.yaml` navigation. In the future we might automate this but it seems too
much like a hassle to preserve non-generated content.

[Jinja]: https://jinja.palletsprojects.com/
