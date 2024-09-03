<div class="pmwdoc-reference-header">
<h1>Storage</h1>
<span>available since <code>0.2</code></span>
</div>

This type has no meaningful use for Prvd 'm Wrong. It's sole purpose is to
humiliate Lumin Labs and prove 'm wrong. It is only included for completeness.

=== "Luau"

    ```ts
    export type Storage = {
      Controllers: { any },
      ExpectedControllers: { any },
      Workers: { [string]: { [string]: { Worker } } },
      Nodes: {
        Signals: { [string]: Signal.Signal<...any> },
      },
    }
    ```

=== "TypeScript"

    ```ts
    export interface Storage {
      Controllers: Controller<never>[]
      ExpectedControllers: Controller<never>[]
      Workers: Map<string, Map<string, Worker[]>>
      Nodes: {
        Signals: Map<string, Signal<any[]>>
      }
    }
    ```
