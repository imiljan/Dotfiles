return {
  -- {
  --   "catppuccin/nvim",
  --   lazy = true,
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "mocha",
  --       transparent_background = true,
  --       term_colors = true,
  --       dim_inactive = {
  --         enabled = false,
  --         shade = "dark",
  --         percentage = 0.50,
  --       },
  --       no_italic = false,
  --       no_bold = false,
  --       no_underline = false,
  --       integrations = {
  --         alpha = true,
  --         fidget = true,
  --         gitsigns = true,
  --         harpoon = true,
  --         indent_blankline = {
  --           enabled = true,
  --           colored_indent_levels = false,
  --         },
  --         markdown = true,
  --         mason = true,
  --         mini = {
  --           enabled = true,
  --           indentscope_color = "",
  --         },
  --         neotree = true,
  --         neotest = true,
  --         cmp = true,
  --         dap = true,
  --         dap_ui = true,
  --         telescope = {
  --           enabled = true,
  --           style = "classic",
  --           -- style = "nvchad",
  --         },
  --         lsp_trouble = true,
  --         which_key = true,
  --       },
  --     })
  --   end,
  -- },
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
      -- vim.cmd.hi("Comment gui=none")
    end,
  },
}
