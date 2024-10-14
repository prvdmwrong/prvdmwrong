export type Package = {
  name: string,
  absolutePath: string,
  relativePath: string,
}

export type Registry = {
  process: (package: Package) -> (),
  publish: (package: Package) -> (),
}

return nil
