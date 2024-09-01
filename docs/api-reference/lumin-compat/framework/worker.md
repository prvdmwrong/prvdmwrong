<div class="pmwdoc-reference-header">
<h1>Worker</h1>
<span>available since <code>v0.2</code></span>
</div>

=== "Luau"

    ```ts
    function Worker(
      type: WorkerType,
      callback: (...any) -> ()
    ): Worker
    ```

=== "TypeScript"

    ```ts
    export interface Worker<Type extends WorkerType = any> {
      Type: Type
      Callback(...args: InferWorkerArgs<Type>): void
      IsWorker: boolean
    }
    ```
