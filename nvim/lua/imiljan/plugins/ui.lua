return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- night, storm, day, moon
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
    end,
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        enabled = true,
        relative = "editor",
        max_width = { 140, 0.9 },
        min_width = { 40, 0.4 },
      },
      select = {
        enabled = true,
        builtin = {
          relative = "editor",
        },
      },
    },
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
      { "<leader>bn", "<cmd>tabnew<cr>", desc = "BufLine: New" },
      { "<leader>bq", "<cmd>tabclose<cr>", desc = "BufLine: Close Current" },

      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "BufLine: Toggle Pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "BufLine: Delete Non-Pinned" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "BufLine: Delete Other" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "BufLine: Delete to the Right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "BufLine: Delete to the Left" },

      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "BufLine: Prev" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "BufLine: Next" },

      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "BufLine: Prev" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "BufLine: Next" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "BufLine: Move prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "BufLine: Move next" },

      { "<leader>tt", "<cmd>tabnew<cr>", desc = "TAB: open new" },
      { "<leader>tq", "<cmd>tabclose<cr>", desc = "TAB: close current" },
      { "<leader>tn", "<cmd>tabn<cr>", desc = "TAB: go to next" },
      { "<leader>tp", "<cmd>tabp<cr>", desc = "TAB: go to prev" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/trouble.nvim",
    },
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
          lualine_x = {},
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
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    main = "ibl",
    opts = { scope = { enabled = false } },
  },
}
