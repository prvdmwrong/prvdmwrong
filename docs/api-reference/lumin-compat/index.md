<div class="pmwdoc-reference-breadcrumbs">
<a href="../">API Reference</a>
</div>

# Lumin Compat

This package provides a compatibility layer between Lumin Framework and Prvd 'M
Wrong. It preserves controller types, worker APIs and promise-based startup.

Like other compatibility packages, this package can be used as a drop-in
replacement for Lumin Framework. Just change where you require the original
framework, and let Prvd 'M Wrong do the heavy lifting.

## Installation

=== "Wally"

    ```TOML
    [dependencies]
    Lumin = "prvdmwrong/lumin-compat@0.2.0-dev.16"
    ```

=== "Node"

    ```Bash
    npm i @prvdmwrong/lumin-compat
    pnpm i @prvdmwrong/lumin-compat
    yarn add @prvdmwrong/lumin-compat
    ```

=== "Pesde"

    ```YAML
    dependencies:
    - Lumin:
      - name: prvdmwrong/lumin-compat
      - version: 0.2.0-dev.16
    ```

<section class="grid" markdown>

<section markdown>

<h2 style="margin-bottom: 0;">Framework</h2>

- [Controller](./framework/controller.md)
- [Expect](./framework/expect.md)
- [Signal](./framework/signal.md)
- [Start](./framework/start.md)
- [Started](./framework/started.md)
- [Worker](./framework/worker.md)

</section>

<section markdown>

<h2 style="margin-bottom: 0;">Types</h2>

- [Storage](./types/storage.md)
- [WorkerType](./types/worker-type.md)
- [Worker](./types/worker.md)

</section>

</section>
