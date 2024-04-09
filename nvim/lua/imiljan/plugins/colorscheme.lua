-- return {
-- 	"catppuccin/nvim",
-- 	lazy = false,
-- 	name = "catppuccin",
-- 	priority = 1000,
-- 	config = function()
-- 		require("catppuccin").setup({
-- 			flavour = "mocha", -- latte, frappe, macchiato, mocha
-- 			transparent_background = false, -- disables setting the background color.
-- 			dim_inactive = {
-- 				enabled = true, -- dims the background color of inactive window
-- 				shade = "dark",
-- 				percentage = 0.50, -- percentage of the shade to apply to the inactive window
-- 			},
-- 			integrations = {
-- 				fidget = true,
-- 				indent_blankline = {
-- 					enabled = true,
-- 					scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
-- 					colored_indent_levels = false,
-- 				},
-- 				mason = true,
-- 				neotree = true,
-- 				telescope = {
-- 					enabled = true,
-- 					style = "nvchad"
-- 				},
-- 				lsp_trouble = true,
-- 				which_key = true
-- 			},
-- 		})
--
-- 		vim.cmd.colorscheme("catppuccin")
-- 	end,
-- }

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "storm",
      transparent = true,
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = false },
        keywords = { italic = false },
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "transparent",       -- style for sidebars, see below
        floats = "transparent",         -- style for floating windows
      },
      hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
      dim_inactive = true,              -- dims inactive windows
      lualine_bold = false,             -- When `true`, section headers in the lualine theme will be bold
    })
    vim.cmd.colorscheme("tokyonight-night")
    vim.cmd.hi("Comment gui=none")
  end,
}
