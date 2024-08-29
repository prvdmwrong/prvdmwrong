---
hide:
  - toc
---

<div class="pmwdoc-reference-breadcrumbs">
<a href="../">API Reference</a>
</div>

# :octicons-list-unordered-16: Core

This package contains fundamental primitives for creating and using game
providers. Contains everything needed to bootstrap a Roblox game and utilities
for extending the core Prvd 'M Wrong package.

Install this through your preferred package manager:

=== "Wally"

    ```toml
    [dependencies]
      prvd = "prvdmwrong/core@0.2.0-dev.5"
    ```

=== "Pesde"

    ```yaml
    dependencies:
    - prvd:
      - name: prvdmwrong/core
      - version: 0.2.0-dev.5
    ```

=== "NPM"

    ```bash
    $ npm i @prvdmwrong/core
    ```

=== "PNPM"

    ```bash
    $ pnpm i @prvdmwrong/core
    ```

=== "Yarn"

    ```bash
    $ yarn add @prvdmwrong/core
    ```

---

<section class="grid" markdown>

<section markdown>

## [Providers](providers/index.md)

- [:octicons-package-16: Provider](providers/provider.md)
- [:octicons-package-16: new](providers/new.md)
- [:octicons-list-ordered-16: StartupStatus](providers/startup-status.md)
- [:octicons-code-16: preload](providers/preload.md)
- [:octicons-code-16: start](providers/start.md)
- [:octicons-workflow-16: awaitStart](providers/await-start.md)
- [:octicons-workflow-16: onStart](providers/on-start.md)

## [Types](types/index.md)

- [:octicons-checklist-16: Lifecycle](types/lifecycle.md)
- [:octicons-checklist-16: OnInit](types/on-init.md)
- [:octicons-checklist-16: OnStart](types/on-start.md)
- [:octicons-checklist-16: Options](types/options.md)
- [:octicons-checklist-16: Provider](types/provider.md)

</section>

<section markdown>

## [Lifecycles](lifecycles/index.md)

- [:octicons-package-16: Lifecycle](lifecycles/lifecycle.md)
- [:octicons-code-16: fireConcurrent](lifecycles/fire-concurrent.md)
- [:octicons-code-16: fireSequential](lifecycles/fire-sequential.md)
- [:octicons-workflow-16: onLifecycleRegistered](lifecycles/on-lifecycle-registered.md)
- [:octicons-workflow-16: onLifecycleUnregistered](lifecycles/on-lifecycle-unregistered.md)

## [Modding](modding/index.md)

- [:octicons-code-16: getStartupOptions](modding/get-startup-options.md)
- [:octicons-code-16: getStartupStatus](modding/get-startup-status.md)
- [:octicons-workflow-16: onProviderConstructed](modding/on-provider-constructed.md)
- [:octicons-workflow-16: onProviderUsed](modding/on-provider-used.md)

## [Internal](internal/index.md)

- [:octicons-code-16: defineMetadata](internal/define-metadata.md)
- [:octicons-code-16: deleteMetadata](internal/delete-metadata.md)
- [:octicons-code-16: getMetadata](internal/get-metadata.md)
- [:octicons-code-16: registerAll](internal/register-all.md)
- [:octicons-code-16: registerDependency](internal/register-dependency.md)
- [:octicons-code-16: registerMethod](internal/register-method.md)
- [:octicons-code-16: unregisterMethod](internal/unregister-method.md)

</section>

</section>
