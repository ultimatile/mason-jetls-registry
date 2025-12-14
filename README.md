# Mason JETLS Registry

Custom [Mason](https://github.com/mason-org/mason.nvim) registry for installing [JETLS.jl](https://github.com/aviatesk/JETLS.jl)

## Prerequisites

- Julia (v1.12.0 or higher)
- Git
- Neovim with Mason installed

## Installation

### 1. Registry Setup

The registry is located at:

```
~/ghq/github.com/ultimatile/mason-jetls-registry
```

### 2. Neovim Configuration

Add the Mason configuration to your Neovim setup.
For LazyVim, create or update something like `nvim/lua/plugins/mason.lua`:

```lua
return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    -- Add custom registry path to Lua package path
    local registry_path = vim.fn.expand("~/ghq/github.com/ultimatile/mason-jetls-registry")
    if vim.fn.isdirectory(registry_path) == 1 then
      package.path = package.path .. ";" .. registry_path .. "/lua/?.lua"
      package.path = package.path .. ";" .. registry_path .. "/lua/?/init.lua"
    end

    opts.registries = opts.registries or {}
    table.insert(opts.registries, 1, "lua:mason-jetls-registry")

    return opts
  end,
}
```

### 3. Install JETLS

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

The custom registry:

1. Clones JETLS.jl from GitHub
2. Installs Julia dependencies using `Pkg.instantiate()`
3. Creates a wrapper script (`jetls`) that launches the server
4. Makes the wrapper executable

The wrapper script runs:

```bash
julia --startup-file=no --project=/path/to/JETLS.jl /path/to/JETLS.jl/runserver.jl
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

## Registry Structure

```
mason-jetls-registry/
├── README.md
└── lua/
    └── mason-jetls-registry/
        ├── init.lua        # Registry index
        └── jetls.lua       # JETLS package definition
```

## References

- [JETLS.jl Repository](https://github.com/aviatesk/JETLS.jl)
- [Mason Registry Examples](https://github.com/mason-org/registry-examples)
- [Mason Official Registry](https://github.com/mason-org/mason-registry)
