return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,
				-- JS/TS
				-- null_ls.builtins.formatting.prettier,
				-- null_ls.builtins.diagnostics.eslint,
				require("none-ls.diagnostics.eslint_d"),
				null_ls.builtins.formatting.prettierd,

				-- Python
				null_ls.builtins.diagnostics.mypy,
				require("none-ls.diagnostics.ruff"),
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,

				-- All
				-- null_ls.builtins.completion.spell,
				require("none-ls.formatting.jq"),
				-- Codespell finds common misspellings in text files.
				-- null_ls.builtins.diagnostics.codespell,
				-- GH Actions
				null_ls.builtins.diagnostics.actionlint,
				-- Makefiles
				null_ls.builtins.diagnostics.checkmake,
				-- A smarter Dockerfile linter that helps you build best practice Docker images.
				null_ls.builtins.diagnostics.hadolint,
				-- YML
				require("none-ls.diagnostics.yamllint"),
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
