# Development

## Local testing

Point Mason at a working tree using the `file:` registry form:

```lua
return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    opts.registries = opts.registries or {
      "github:mason-org/mason-registry",
    }
    table.insert(opts.registries, 1, "file:/path/to/mason-jetls-registry")
    return opts
  end,
}
```

After editing `packages/jetls/package.yaml`, restart Neovim and reinstall:

```vim
:MasonUninstall jetls
:MasonInstall jetls
```

## Package definition

`packages/jetls/package.yaml` consumes the per-platform sysimage zip published by [`ultimatile/jetls-sysimage`](https://github.com/ultimatile/jetls-sysimage):

- One asset per platform (`linux_x64`, `darwin_arm64`, `win_x64`).
- The shim under `bin/` inside the zip wraps `julia --sysimage <built-image> -m JETLS`.

## Updating the upstream version

The `<version>` in `source.id` (`pkg:github/ultimatile/jetls-sysimage@<version>`) is tracked by Renovate. When `jetls-sysimage` publishes a new release, Renovate opens a PR bumping that pin.

## Continuous testing

`.github/workflows/test.yml` runs on every PR that touches `packages/*/package.yaml`. It downloads the sysimage zip referenced by `source.id` on Linux, macOS, and Windows runners and asserts that the bundled shim responds to `--version`.

## Automated releases

Releases are produced by `mason-org/actions/registry-release` whenever `packages/` changes on `main`:

1. Detects changes to package definitions.
2. Generates a timestamped tag (e.g. `2026-01-18-adjective-noun`).
3. Compiles `package.yaml` to `registry.json`.
4. Publishes a GitHub release with `registry.json`, `registry.json.zip`, and `checksums.txt`.

The release action requires non-merge commits to detect changes. When merging PRs, use **Squash and merge**.

## Manual release

```bash
gh workflow run release.yml
```

A manual run only produces a release if the latest commit on `main` is a non-merge commit that modified `packages/`.
