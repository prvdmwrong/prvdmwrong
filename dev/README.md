# Prvd 'M Wrong Devtesting

This directory contains a game to help bugtest Prvd 'M Wrong.

## Developing

```Bash
rojo sourcemap -o sourcemap.json --watch test.project.json
```

## Testing

Build Prvd 'M Wrong:

```Bash
$ lune run build
✔ Distribute these packages to Wally/Pesde/NPM? · yes
✔ Enter a valid semver version to distribute › 0.2.0
```

Serve the project:

```Bash
rojo serve test.project.json
```
