# linear-import-nix

> **NOTE**: The `package.json` contains all the dependencies of the toplevel
> `package.json` (taken from
> https://github.com/linear/linear/blob/5cc44ba1ae86170ad54b2b3a99981b34a2d779a9/package.json),
> as well as those from the child `package.json` for the importer itself (taken
> from
> https://github.com/linear/linear/blob/5cc44ba1ae86170ad54b2b3a99981b34a2d779a9/packages/import/package.json).

## Usage

```console
$ nix build .#linear-import
$ result/bin/importer
```
