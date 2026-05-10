# Mason JETLS Registry

Custom [Mason](https://github.com/mason-org/mason.nvim) registry for installing [JETLS.jl](https://github.com/aviatesk/JETLS.jl).

The package installs a pre-built sysimage of JETLS.jl from [`ultimatile/jetls-sysimage`](https://github.com/ultimatile/jetls-sysimage), so the language server starts without paying the JETLS.jl precompile cost on every launch.

## Prerequisites

- Julia 1.12 (the sysimage is built against 1.12 and will not load on other Julia versions)
- Neovim with Mason installed

## Installation

Register this registry with Mason. For LazyVim, create or update `lua/plugins/mason.lua`:

```lua
return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    opts.registries = opts.registries or {
      "github:mason-org/mason-registry",
    }
    table.insert(opts.registries, 1, "github:ultimatile/mason-jetls-registry")
    return opts
  end,
}
```

Then install the package from inside Neovim:

```vim
:MasonInstall jetls
```

## LSP Configuration

For LazyVim with `nvim-lspconfig`:

```lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      jetls = {
        -- server-specific settings can go here
      },
    },
  },
}
```

## Troubleshooting

### Julia not found

The shim invokes whichever `julia` is on `PATH`:

```bash
which julia
julia --version
```

To pin a specific Julia, set `JULIA_BIN` in the environment Neovim runs under.

### Installation fails

```vim
:MasonLog
```

### Server doesn't start

Verify the installed shim runs:

```bash
~/.local/share/nvim/mason/bin/jetls --version
```

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md).

## References

- [JETLS.jl](https://github.com/aviatesk/JETLS.jl) — upstream language server
- [jetls-sysimage](https://github.com/ultimatile/jetls-sysimage) — the sysimage build pipeline whose releases this registry consumes
- [Mason.nvim](https://github.com/mason-org/mason.nvim)
