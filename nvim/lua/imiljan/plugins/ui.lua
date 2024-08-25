return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          -- sidebars = "transparent",
          -- floats = "transparent",
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
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                     ]],
        [[       ████ ██████           █████      ██                     ]],
        [[      ███████████             █████                             ]],
        [[      █████████ ███████████████████ ███   ███████████   ]],
        [[     █████████  ███    █████████████ █████ ██████████████   ]],
        [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
        [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
        [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
      }

      -- default https://github.com/goolord/alpha-nvim/blob/main/lua/alpha/themes/dashboard.lua
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", "<cmd>ene <CR>"),
        dashboard.button("<C-p>", "󰈞  Git/Project files"),
        dashboard.button("SPC s f", "󰈞  Find files"),
        dashboard.button("SPC s g", "󰈬  Find word"),
        dashboard.button("SPC s .", "󰊄  Recently opened files"),
        dashboard.button("SPC s m", "  Jump to marks"),
        dashboard.button("SPC q l", "  Open last session"),
        dashboard.button("SPC s n", "  Config"),
      }

      alpha.setup(dashboard.config)
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
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "BufLine: Toggle Pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "BufLine: Delete Non-Pinned" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "BufLine: Delete Other" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "BufLine: Delete to the Right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "BufLine: Delete to the Left" },

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
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })

      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 }, { symbols.get, cond = symbols.has } },
          lualine_x = { "kulala", "encoding", "filetype" },
          lualine_y = { "progress" },
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
    opts = {
      scope = {
        enabled = false,
      },
    },
  },
  { -- echasnovski/mini
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- LazyFile
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "alpha",
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "toggleterm",
          "Trouble",
          "trouble",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
