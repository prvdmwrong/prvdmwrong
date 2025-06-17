default:

serve-test-runner:
    rojo sourcemap --watch -o sourcemap.json test-runner.project.json \
        & rojo serve test-runner.project.json
