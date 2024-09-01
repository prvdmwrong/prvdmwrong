<div class="pmwdoc-reference-header">
<h1>Storage</h1>
<span>available since <code>v0.2</code></span>
</div>

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
