return {
  { "tpope/vim-sleuth" },
  { "numToStr/Comment.nvim", opts = {} },
  { "echasnovski/mini.ai", opts = { n_lines = 500 } },
  { "echasnovski/mini.surround", opts = { n_lines = 100 } },
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Suggested
      "BurntSushi/ripgrep",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- Optional
      "sharkdp/fd",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      -- Extensions
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-github.nvim",
      -- Other
      "folke/trouble.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local telescope_actions = require("telescope.actions")
      local telescope_actions_layout = require("telescope.actions.layout")
      local telescope_builtin = require("telescope.builtin")

      local trouble = require("trouble.sources.telescope")

      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              height = 0.95,
              preview_cutoff = 120,
              prompt_position = "top",
              width = 0.9,
            },
            vertical = {
              height = 0.95,
              preview_cutoff = 40,
              prompt_position = "top",
              width = 0.9,
            },
          },
          border = true,
          path_display = { "truncate" },
          dynamic_preview_title = true,
          mappings = {
            i = {
              ["<C-h>"] = "which_key",
              ["<C-f>"] = telescope_actions_layout.cycle_layout_next,
              ["<C-j>"] = telescope_actions.cycle_history_next,
              ["<C-k>"] = telescope_actions.cycle_history_prev,
              ["<C-t>"] = trouble.open,
            },
            n = {
              ["<C-h>"] = "which_key",
              ["<C-f>"] = telescope_actions_layout.cycle_layout_next,
              ["<C-j>"] = telescope_actions.cycle_history_next,
              ["<C-k>"] = telescope_actions.cycle_history_prev,
              ["<C-t>"] = trouble.open,
            },
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
          ["file_browser"] = { hijack_netrw = false },
        },
      })

      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "file_browser")
      pcall(telescope.load_extension, "gh")

      vim.keymap.set("n", "<C-p>", function()
        local ok = pcall(telescope_builtin.git_files, { use_git_root = false, show_untracked = true })
        if not ok then
          telescope_builtin.find_files()
        end
      end, { desc = "SEARCH: Git/Project Files" })

      vim.keymap.set("n", "<leader>sf", telescope_builtin.find_files, { desc = "SEARCH: Files" })
      vim.keymap.set("n", "<leader>sF", function()
        telescope_builtin.find_files({ file_ignore_patterns = { "node_modules", ".git", ".venv" }, hidden = true })
      end, { desc = "SEARCH: Files (hidden)" })
      vim.keymap.set("n", "<leader>sg", telescope_builtin.live_grep, { desc = "SEARCH: Grep" })
      vim.keymap.set("n", "<leader>sw", telescope_builtin.grep_string, { desc = "SEARCH: Current Word" })
      vim.keymap.set("n", "<leader>sW", function()
        vim.ui.input({ prompt = "Grep > " }, function(input)
          telescope_builtin.grep_string({ search = input })
        end)
      end, { desc = "SEARCH: Grep with input" })

      vim.keymap.set("n", "<leader>sd", function()
        vim.ui.input({
          prompt = "Directory > ",
          completion = "file",
          default = vim.uv.cwd(),
        }, function(input)
          telescope_builtin.live_grep({ search_dirs = { input }, prompt_title = "Live Grep in Directory" })
        end)
      end, { desc = "SEARCH: Live Grep in Directory" })

      vim.keymap.set("n", "<leader>s/", function()
        telescope_builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
      end, { desc = "SEARCH: Live Grep in Open Files" })

      vim.keymap.set("n", "<leader>s.", telescope_builtin.oldfiles, { desc = "SEARCH: Recent Files" })
      vim.keymap.set("n", '<leader>s"', telescope_builtin.registers, { desc = "SEARCH: Registers" })
      vim.keymap.set("n", "<leader>sb", telescope_builtin.buffers, { desc = "SEARCH: Existing buffers" })
      vim.keymap.set("n", "<leader>sc", telescope_builtin.commands, { desc = "SEARCH: Commands" })
      vim.keymap.set("n", "<leader>sh", telescope_builtin.help_tags, { desc = "SEARCH: Help" })
      vim.keymap.set("n", "<leader>sk", telescope_builtin.keymaps, { desc = "SEARCH: Keymaps" })
      vim.keymap.set("n", "<leader>sm", telescope_builtin.marks, { desc = "SEARCH: Marks" })
      vim.keymap.set("n", "<leader>sr", telescope_builtin.resume, { desc = "SEARCH: Resume" })

      vim.keymap.set("n", "<leader>/", function()
        telescope_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false }))
      end, { desc = "SEARCH: in current buffer" })

      vim.keymap.set("n", "<leader>ss", telescope_builtin.builtin, { desc = "SEARCH: Select Telescope" })
      vim.keymap.set("n", "<leader>sn", function()
        telescope_builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "SEARCH: Neovim files" })

      vim.keymap.set("n", "<leader>cs", telescope_builtin.spell_suggest, { desc = "SEARCH: Spell Suggestions" })

      vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser, { desc = "Telescope: FileBrowser" })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      source_selector = { winbar = true, statusline = true },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { "node_modules", ".git", ".husky", ".idea", ".vscode" },
          hide_by_pattern = {},
          always_show = {},
          always_show_by_pattern = {},
          never_show = { ".DS_Store" },
          never_show_by_pattern = {},
        },
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "disabled",
      },
      window = {
        mappings = {
          ["Y"] = require("imiljan.util.neo-tree").copy_path,
        },
      },
    },
    keys = {
      {
        "<C-n>",
        function()
          require("neo-tree.command").execute({ toggle = true })
        end,
        desc = "NeoTree: Toggle",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    config = function()
      local wk = require("which-key")
      wk.setup({
        icons = { mappings = false },
      })

      wk.add({
        { "<leader>S", group = "Search and Replace" },
        { "<leader>a", group = "Harpoon" },
        { "<leader>b", group = "Bufferline" },
        { "<leader>c", group = "Code Actions" },
        { "<leader>d", group = "Document/Debug/Delete" },
        { "<leader>e", group = "Diagnoctic: Show message" },
        { "<leader>f", group = "Format/Diagnostics/FileBrowser" },
        { "<leader>g", group = "Git", mode = { "n", "v" } },
        { "<leader>gt", group = "Git Toggle" },
        { "<leader>h", group = "HTTP" },
        { "<leader>l", group = "LSPHints/LocList/LazyGit/Wrap" },
        { "<leader>o", group = "Outline" },
        { "<leader>q", group = "Quickfix list / Persistence" },
        { "<leader>r", group = "Rename" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Test/Tab" },
        { "<leader>u", group = "UndoTree" },
        { "<leader>v", group = "VenvSelect" },
        { "<leader>w", group = "LSP Workspace search" },
        { "<leader>x", group = "Trouble" },
        { "<leader>z", group = "Zen" },
        { "[", group = "Previous ..." },
        { "]", group = "Next ..." },
      })
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>Ss",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble<cr>", desc = "Trouble" },
      { "<leader>xc", "<cmd>Trouble close<cr>", desc = "Trouble: close" },

      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: Buffer Diagnostics" },
      { "<leader>xD", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: Diagnostics" },

      { "<leader>xr", "<cmd>Trouble lsp_references toggle focus=false<cr>", desc = "Trouble: LSP References" },
      { "<leader>xL", "<cmd>Trouble lsp toggle focus=false<cr>", desc = "Trouble: LSP" },

      { "<leader>xs", "<cmd>Trouble symbols toggle win.position=bottom focus=false<cr>", desc = "Trouble: Symbols" },

      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: Location List" },
      { "<leader>lo", "<cmd>lopen<cr>", desc = "LocationList: open" },
      { "<leader>lc", "<cmd>lclose<cr>", desc = "LocationList: close" },
      { "]l", "<cmd>lnext<cr>", desc = "LocationList: next" },
      { "[l", "<cmd>lprev<cr>", desc = "LocationList: prev" },

      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: Quickfix List" },
      { "<leader>qo", "<cmd>copen<cr>", desc = "QuickFix: open" },
      { "<leader>qc", "<cmd>cclose<cr>", desc = "QuickFix: close" },

      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "QuickFix/Trouble: prev",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "QuickFix/Trouble: next",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    keys = {
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Trouble: Todo" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Trouble: Todo/Fix/Fixme" },

      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "SEARCH: Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "SEARCH: Todo/Fix/Fixme" },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "TODO: prev",
      },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "TODO: next",
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    opts = { window = { width = 140 } },
    cmd = { "ZenMode" },
    keys = { { "<leader>zz", "<cmd>ZenMode<cr>", desc = "ZenMode: Toggle" } },
  },
}
