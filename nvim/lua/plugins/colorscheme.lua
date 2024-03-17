-- catppuccin
return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			transparent_background = false, -- disables setting the background color.
			dim_inactive = {
				enabled = true, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.50, -- percentage of the shade to apply to the inactive window
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}

-- tokyonight
-- return {
-- 	"folke/tokyonight.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("tokyonight").setup({
-- 			transparent = false,
-- 		})
-- 		vim.cmd.colorscheme("tokyonight-night")
-- 		-- You can configure highlights by doing something like
-- 		-- vim.cmd.hi("Comment gui=none")
-- 	end,
-- }
