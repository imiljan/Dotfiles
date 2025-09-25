return {
  { "tpope/vim-sleuth" },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      local ft = require("Comment.ft")
      ft.set("http", { "#%s", "#%s" })
    end,
  },
  { "echasnovski/mini.surround", opts = { n_lines = 100 } },
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "sharkdp/fd",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-github.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-dap.nvim",
      { "AckslD/nvim-neoclip.lua", opts = {} },
      "folke/trouble.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local actions_layout = require("telescope.actions.layout")
      local builtin = require("telescope.builtin")

      local trouble = require("trouble.sources.telescope")

      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_strategy = "flex",
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
              ["<C-f>"] = actions_layout.cycle_layout_next,
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<C-t>"] = trouble.open,
            },
            n = {
              ["<C-h>"] = "which_key",
              ["<C-f>"] = actions_layout.cycle_layout_next,
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<C-t>"] = trouble.open,
            },
          },
        },
        pickers = {
          git_files = {
            use_git_root = false,
            show_untracked = true,
          },
          find_files = {
            hidden = true,
            no_ignore = true,
            file_ignore_patterns = { "node_modules", "lib", "dist", ".git", ".venv" },
          },
          live_grep = {
            additional_args = { "--fixed-strings" },
          },
          buffers = {
            sort_lastused = true,
            sort_mru = true,
          },
          colorscheme = {
            enable_preview = true,
          },
        },
        extensions = {
          ["fzf"] = {},
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
          -- ["file_browser"] = { hijack_netrw = false },
        },
      })

      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
      -- pcall(telescope.load_extension, "file_browser")
      pcall(telescope.load_extension, "gh")
      pcall(telescope.load_extension, "neoclip")

      vim.keymap.set("n", "<C-p>", function()
        local ok = pcall(builtin.git_files)
        if not ok then
          builtin.find_files()
        end
      end, { desc = "🔭: Git/Project Files" })

      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "🔭: Files" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "🔭: Grep" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "🔭: Grep Word" })
      vim.keymap.set("n", "<leader>sW", function()
        vim.ui.input({ prompt = "Grep > " }, function(input)
          builtin.grep_string({ search = input })
        end)
      end, { desc = "🔭: Grep with input" })

      vim.keymap.set("n", "<leader>sd", function()
        vim.ui.input({
          prompt = "Directory > ",
          completion = "file",
          default = vim.uv.cwd(),
        }, function(input)
          builtin.live_grep({ search_dirs = { input }, prompt_title = "Live Grep in Directory" })
        end)
      end, { desc = "🔭: Live Grep in Directory" })

      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false }))
      end, { desc = "🔭: Grep in current buffer" })

      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
      end, { desc = "🔭: Live Grep in Open Files" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "🔭: Old Files" })
      vim.keymap.set("n", '<leader>s"', builtin.registers, { desc = "🔭: Registers" })
      vim.keymap.set("n", "<leader>sa", builtin.builtin, { desc = "🔭: Builtin" })
      vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "🔭: Buffers" })
      vim.keymap.set("n", "<leader>sc", builtin.command_history, { desc = "🔭: Command History" })
      vim.keymap.set("n", "<leader>sC", builtin.commands, { desc = "🔭: Commands" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "🔭: Help" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "🔭: Keymaps" })
      vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "🔭: Marks" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "🔭: Resume" })
      vim.keymap.set("n", "<leader>cS", builtin.spell_suggest, { desc = "🔭: Spell Suggestions" })

      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "🔭: Neovim files" })

      vim.keymap.set("n", "<leader>fe", builtin.symbols, { desc = "🔭: Emojis" })
      -- vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser, { desc = "🔭: FileBrowser" })
      vim.keymap.set("n", "<leader>fc", telescope.extensions.neoclip.default, { desc = "🔭: Clipboard" })

      -- vim.keymap.set("n", "<leader>hg", function()
      --   vim.ui.input({ prompt = "HTTP name >" }, function(input)
      --     builtin.grep_string({
      --       search = "@name " .. input,
      --       additional_args = { "--glob=*.http" },
      --     })
      --   end)
      -- end, { noremap = true, silent = true, desc = "HTTP: Grep by name" })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = true,
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
    config = function(_, opts)
      require("neo-tree").setup(opts)
      local events = require("neo-tree.events")

      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end

      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })

      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
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
        { "<leader>E", group = "Diagnostics: QuickFix" },
        { "<leader>G", group = "Git (🔭)" },
        { "<leader>S", group = "Workspace Symbols with input" },
        { "<leader>a", group = "Harpoon" },
        { "<leader>b", group = "Bufferline" },
        { "<leader>c", group = "Code Actions" },
        { "<leader>d", group = "Document/Debug/Delete" },
        { "<leader>e", group = "Diagnoctic: Show message" },
        { "<leader>f", group = "Format/Diagnostics/FileBrowser" },
        { "<leader>g", group = "Git", mode = { "n", "v" } },
        { "<leader>gB", group = " GitHub Browser" },
        { "<leader>gf", group = "Git Fugitive" },
        { "<leader>gt", group = "Git Toggle" },
        { "<leader>h", group = "HTTP" },
        { "<leader>l", group = "LSPHints/LocList/LazyGit/Wrap" },
        { "<leader>o", group = "Outline/Overseer" },
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
        "<leader>sR",
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
    opts = {
      auto_preview = false,
      focus = true,
      preview = {
        type = "float",
        border = "rounded",
        title = "Preview",
        title_pos = "center",
        size = { width = 0.9, height = 0.95 },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble<cr>", desc = "Trouble" },
      { "<leader>xc", "<cmd>Trouble close<cr>", desc = "Trouble: close" },

      { "<leader>X", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: Diagnostics" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: Buffer Diagnostics" },
      { "<leader>xD", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: Diagnostics" },

      { "<leader>xr", "<cmd>Trouble lsp_references toggle focus=false<cr>", desc = "Trouble: LSP References" },
      { "<leader>xL", "<cmd>Trouble lsp toggle focus=false<cr>", desc = "Trouble: LSP" },

      { "<leader>xs", "<cmd>Trouble symbols toggle win.position=bottom focus=false<cr>", desc = "Trouble: Symbols" },

      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: Location List" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: Quickfix List" },

      {
        "<C-Up>",
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
        "<C-Down>",
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

      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "🔭: Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "🔭: Todo/Fix/Fixme" },
      -- {
      --   "[t",
      --   function()
      --     require("todo-comments").jump_prev()
      --   end,
      --   desc = "TODO: prev",
      -- },
      -- {
      --   "]t",
      --   function()
      --     require("todo-comments").jump_next()
      --   end,
      --   desc = "TODO: next",
      -- },
    },
  },
}
