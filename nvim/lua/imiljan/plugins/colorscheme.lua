return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = "transparent",
          floats = "transparent",
        },
        sidebars = { "terminal", "help", "neo-tree" },
        hide_inactive_statusline = false,
        dim_inactive = true,
        lualine_bold = false,
        on_colors = function() end,
        on_highlights = function() end,
      })

      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
