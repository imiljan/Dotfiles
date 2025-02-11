return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- night, storm, day, moon
        light_style = "day",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "terminal", "help", "neo-tree" },
        hide_inactive_statusline = false,
        day_brightness = 0.3,
        dim_inactive = true,
        lualine_bold = false,
        on_colors = function() end,
        on_highlights = function() end,
        cache = true,
        plugins = {
          all = true,
          auto = true,
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        mode = "tabs",
        tab_size = 5,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            separator = true,
            text_align = "left",
          },
        },
        separator_style = "slant",
      },
    },
    keys = {
      { "<leader>tt", "<cmd>tabnew<cr>", desc = "TAB: open new" },
      { "<leader>tq", "<cmd>tabclose<cr>", desc = "TAB: close current" },
      { "<leader>tn", "<cmd>tabn<cr>", desc = "TAB: go to next" },
      { "<leader>tp", "<cmd>tabp<cr>", desc = "TAB: go to prev" },

      { "[t", "<cmd>BufferLineCyclePrev<cr>", desc = "BufLine: Prev" },
      { "]t", "<cmd>BufferLineCycleNext<cr>", desc = "BufLine: Next" },
      { "[T", "<cmd>BufferLineMovePrev<cr>", desc = "BufLine: Move prev" },
      { "]T", "<cmd>BufferLineMoveNext<cr>", desc = "BufLine: Move next" },

      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "BufLine: Prev" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "BufLine: Next" },

      { "<leader>Tp", "<cmd>BufferLineTogglePin<cr>", desc = "BufLine: Toggle Pin" },
      { "<leader>TP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "BufLine: Delete Non-Pinned" },
      { "<leader>To", "<cmd>BufferLineCloseOthers<cr>", desc = "BufLine: Delete Other" },
      { "<leader>Tr", "<cmd>BufferLineCloseRight<cr>", desc = "BufLine: Delete to the Right" },
      { "<leader>Tl", "<cmd>BufferLineCloseLeft<cr>", desc = "BufLine: Delete to the Left" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/trouble.nvim" },
    config = function()
      local symbols = require("trouble").statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })

      require("lualine").setup({
        options = { theme = "auto", globalstatus = true },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", path = 1 }, { symbols.get, cond = symbols.has } },
          lualine_x = { "kulala" },
          lualine_y = { "diagnostics" },
          lualine_z = { "location" },
        },
        extensions = {
          "lazy",
          "mason",
          "neo-tree",
          "nvim-dap-ui",
          "quickfix",
          "trouble",
        },
      })
    end,
  },
}
