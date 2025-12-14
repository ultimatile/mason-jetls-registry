# Mason JETLS Registry

Custom [Mason](https://github.com/mason-org/mason.nvim) registry for installing [JETLS.jl](https://github.com/aviatesk/JETLS.jl)

## Prerequisites

- Julia (v1.12.0 or higher)
- Git
- Neovim with Mason installed

## Installation

### Neovim Configuration

Add the Mason configuration to your Neovim setup.
For LazyVim, create or update `lua/plugins/mason.lua`:

```lua
return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    opts.registries = opts.registries or {
      "github:mason-org/mason-registry",
    }

    -- Add custom JETLS registry
    table.insert(opts.registries, 1, "github:ultimatile/mason-jetls-registry")

    return opts
  end,
}
```

### Install JETLS

Open Neovim and run:

```vim
:Mason
```

Search for `jetls` and install it using `i`.

Alternatively, install from command line:

```vim
:MasonInstall jetls
```

## How It Works

The registry uses a standard YAML-based package definition with `build` instructions:

1. Downloads JETLS.jl from GitHub (tag: 2025-12-12)
2. Runs `julia --project=. -e 'using Pkg; Pkg.instantiate()'` to install dependencies
3. Creates a platform-specific wrapper script:
   - Unix: `bin/jetls` (shell script)
   - Windows: `bin/jetls.cmd` (batch file)
4. Makes the wrapper executable (Unix only)

The wrapper script runs:

```bash
julia --startup-file=no --project=/path/to/JETLS.jl -e 'using JETLS; JETLS.runserver(stdin, stdout)'
```

## LSP Configuration

After installation, configure the LSP in your Neovim setup.
For LazyVim with `nvim-lspconfig`:

```lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      jetls = {
        -- Server-specific settings can be added here
      },
    },
  },
}
```

## Troubleshooting

### Julia not found

Make sure Julia is installed and available in your PATH:

```bash
which julia
julia --version
```

### Installation fails

Check Mason logs:

```vim
:MasonLog
```

### Server doesn't start

Verify the installation:

```bash
~/.local/share/nvim/mason/bin/jetls --help
```

Or check if the wrapper script exists:

```bash
ls -la ~/.local/share/nvim/mason/packages/jetls/bin/
```

## Registry Structure

```
mason-jetls-registry/
├── .github/
│   └── workflows/
│       └── release.yml      # Automated releases via GitHub Actions
├── packages/
│   └── jetls/
│       └── package.yaml     # JETLS package definition
└── README.md
```

## Development

### Local Testing

For rapid development and testing, use the `file:` registry to test changes without pushing to GitHub:

```lua
return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    opts.registries = opts.registries or {
      "github:mason-org/mason-registry",
    }

    -- Use local file registry for development
    table.insert(opts.registries, 1, "file:/path/to/mason-jetls-registry")

    return opts
  end,
}
```

After making changes to `packages/jetls/package.yaml`, restart Neovim and reinstall:

```vim
:MasonUninstall jetls
:MasonInstall jetls
```

### Package Definition

The package is defined in `packages/jetls/package.yaml` using:

- **Source**: `pkg:github/aviatesk/JETLS.jl@2025-12-12`
- **Build Instructions**: Platform-specific scripts for Unix and Windows
- **Bin**: Wrapper script location

### Automated Releases

Releases are automatically created via GitHub Actions when `packages/jetls/package.yaml` is modified. The workflow:

1. Detects changes to package definitions
2. Generates a timestamped tag (e.g., `2025-12-14-adjective-noun`)
3. Compiles `package.yaml` to `registry.json`
4. Creates a GitHub release with:
   - `registry.json`
   - `registry.json.zip`
   - `checksums.txt`

### Manual Release

To trigger a manual release:

```bash
gh workflow run release.yml
```

Or via GitHub UI: Actions → Release → Run workflow

## References

- [JETLS.jl Repository](https://github.com/aviatesk/JETLS.jl)
- [Mason.nvim](https://github.com/mason-org/mason.nvim)
- [Mason Registry Examples](https://github.com/mason-org/registry-examples)
- [Mason Official Registry](https://github.com/mason-org/mason-registry)
