return {
	"nvim-treesitter/nvim-treesitter-context",
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "bash", "lua", "javascript", "typescript", "python" },
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = { -- :help nvim-treesitter-incremental-selection-mod
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<M-space>",
					},
				},
			})
		end,
	},
}
