return {
	name = "jetls",
	description = "JETLS.jl is a Julia Enhanced Type-aware Language Server that provides advanced static analysis and seamless integration with the Julia runtime.",
	categories = { "LSP" },
	homepage = "https://github.com/aviatesk/JETLS.jl",
	languages = { "Julia" },
	licenses = { "MIT" },
	source = {
		id = "pkg:mason/jetls",
		---@param ctx InstallContext
		install = function(ctx)
			ctx.stdio_sink:stdout("Cloning JETLS.jl repository...\n")
			ctx.spawn.git({
				"clone",
				"--depth=1",
				"https://github.com/aviatesk/JETLS.jl.git",
				".",
			})

			-- Check Julia availability
			ctx.stdio_sink:stdout("Checking Julia availability...\n")
			if vim.fn.executable("julia") == 0 then
				error("Julia executable not found in PATH. Please install Julia first.")
			end

			-- Install Julia dependencies
			ctx.stdio_sink:stdout("Installing Julia dependencies...\n")
			local ok, result = pcall(ctx.spawn.julia, {
				"--startup-file=no",
				"--project=.",
				"-e",
				"using Pkg; Pkg.instantiate()",
			})
			if not ok then
				error("Failed to install Julia dependencies: " .. tostring(result))
			end

			-- Create bin directory
			ctx.fs:mkdir("bin")

			-- Create wrapper script
			local wrapper_content
			if vim.fn.has("win32") == 1 then
				-- Windows batch script - uses 'julia' from PATH
				wrapper_content = [[
@echo off
julia --startup-file=no --project=%~dp0.. -e "using JETLS; JETLS.runserver(stdin, stdout)" %*
]]
				ctx.fs:write_file("bin/jetls.cmd", wrapper_content)
			else
				-- Unix shell script - uses 'julia' from PATH
				wrapper_content = [[#!/usr/bin/env sh
# Follow symlinks to find the real script location
SCRIPT="$0"
while [ -L "$SCRIPT" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT")" && pwd)"
  SCRIPT="$(readlink "$SCRIPT")"
  # If SCRIPT is relative, make it absolute
  case "$SCRIPT" in
    /*) ;;
    *) SCRIPT="$SCRIPT_DIR/$SCRIPT" ;;
  esac
done

SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/.."

exec julia --startup-file=no --project="$PROJECT_DIR" -e 'using JETLS; JETLS.runserver(stdin, stdout)' "$@"
]]
				ctx.fs:write_file("bin/jetls", wrapper_content)

				-- Make script executable
				ctx.spawn.chmod({
					"+x",
					"bin/jetls",
				})
			end

			ctx.stdio_sink:stdout("JETLS.jl installed successfully!\n")
		end,
	},
	bin = {
		jetls = vim.fn.has("win32") == 1 and "bin/jetls.cmd" or "bin/jetls",
	},
}
