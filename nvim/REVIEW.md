# Neovim Config Review

## Findings

- High: `nvim-treesitter` is pinned to `branch = "main"` but configured like the old/master API in `lua/imiljan/plugins/coding.lua`. On current main, `require("nvim-treesitter").setup()` is mainly installer config; old modules like `incremental_selection`, `textobjects`, `highlight`, and `indent` are not configured the same way. Either go back to master plus `require("nvim-treesitter.configs").setup(...)`, or fully migrate to the new main-branch model with explicit `vim.treesitter.start()`/indent setup and updated textobjects config.
- High: TypeScript config is split between `tsgo` and `ts_ls` in a way that makes several TS-specific commands dead or unreliable. `tsgo` is enabled and `ts_ls` is disabled in `lua/imiljan/plugins/coding.lua`, but `go_to_source_definition`/`rename_file` are only attached for `client.name == "ts_ls"`, and `lua/imiljan/util/typescript.lua` uses `_typescript.*` commands from `typescript-language-server`. Pick one TypeScript server path and align helpers/keymaps with it.
- Medium: `Comment.nvim` is installed but probably inactive because its setup is commented out in `lua/imiljan/plugins/editor.lua`. Unless lazy.nvim auto-configures this plugin through some side effect, use `opts = {}` or `config = true`.
- Medium: `codespell` runs as a formatter for every filetype on save via `formatters_by_ft["*"]` plus `format_on_save` in `lua/imiljan/plugins/coding.lua`. That can silently rewrite typos in code, docs, strings, or identifiers. Move spelling to lint-only or restrict it to prose filetypes.
- Medium: `go_to_source_definition()` has leftover `print(1)`/`print(2)` debugging and fragile response indexing in `lua/imiljan/util/typescript.lua`. This will pollute command output and can break if the LSP response shape differs.
- Medium: `<leader>ca` and `<leader>cx` LSP keymaps are defined without `buffer = e.buf` in `lua/imiljan/plugins/coding.lua`. Most other LSP mappings are buffer-local, so these should be too.
- Low: Telescope `live_grep` is forced to fixed-string search in `lua/imiljan/plugins/editor.lua`. If intentional, fine. If regex is expected in live grep, this will feel broken.
- Low: Several `vim.ui.input` callbacks do not handle cancel/empty input, for example workspace symbols and directory grep prompts. Cancelling can pass `nil` into Telescope calls.
- Low: `lua/imiljan/plugins/fzf.lua` is entirely commented out, and `lua/imiljan/util/neo-tree.lua` still contains old Neo-tree-specific code even though Neo-tree was removed. This is harmless, but adds noise.
- Low: `which-key` groups have a few stale/misleading labels, for example typo `Diagnoctic` and `<leader>S` labeled as workspace symbols even though it is mapped to Snacks scratch select.

## What Looks Good

- Overall structure is clean: `core`, `plugins`, `lsp`, `util`, and `after/ftplugin` are easy to follow.
- Native Neovim 0.11 LSP config style with `vim.lsp.enable()` and `lsp/*.lua` is used well.
- Lazy loading is mostly sensible and pragmatic.
- The config is clearly tuned for an actual workflow rather than plugin-hoarding.
- Lua syntax parsed cleanly across the checked config files.

## Suggested Order

1. Fix or migrate the Treesitter config.
2. Decide whether TypeScript should use `tsgo` or `ts_ls`, then remove the mismatch.
3. Re-enable/configure `Comment.nvim`.
4. Stop running `codespell` as a universal formatter on save.
5. Clean up stale/comment-only config once behavior is stable.
