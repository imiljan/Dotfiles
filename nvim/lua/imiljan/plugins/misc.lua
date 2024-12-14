return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      indent = {
        enabled = true,
        only_scope = true,
        only_current = true,
        scope = { animate = { enabled = false } },
      },
      input = { enabled = true },
      notifier = { enabled = false },
      rename = { enabled = true },
      scope = {},
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      styles = {},
      words = { enabled = false },
      zen = {
        toggles = {
          dim = false,
          git_signs = true,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer", },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer", },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer", },

      { "<leader>gBl", function() Snacks.gitbrowse() end, desc = "Git: Browse REPO (at line)" },
      { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>ll", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
      { "<leader>lL", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },

      { "<leader>zz",  function() Snacks.zen({ width = 140 }) end, desc = "Toggle Zen Mode" },
      { "<leader>zZ",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        menu = {
          width = vim.api.nvim_win_get_width(0) - 4,
        },
        settings = {
          save_on_toggle = true,
        },
      })

      harpoon:extend({
        UI_CREATE = function(cx)
          vim.keymap.set("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-x>", function()
            harpoon.ui:select_menu_item({ split = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-t>", function()
            harpoon.ui:select_menu_item({ tabedit = true })
          end, { buffer = cx.bufnr })
        end,
      })

      vim.keymap.set("n", "<leader>aa", function()
        harpoon:list():add()
      end, { desc = "Harpoon: Add file" })
      vim.keymap.set("n", "<leader>ar", function()
        harpoon:list():remove()
      end, { desc = "Harpoon: Remove file" })
      vim.keymap.set("n", "<leader>ac", function()
        harpoon:list():clear()
      end, { desc = "Harpoon: Clear all" })
      vim.keymap.set("n", "<leader>ao", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon: Toggle quick menu" })

      vim.keymap.set("n", "<leader>1", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon: Navigate to 1" })
      vim.keymap.set("n", "<leader>2", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon: Navigate to 2" })
      vim.keymap.set("n", "<leader>3", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon: Navigate to 3" })
      vim.keymap.set("n", "<leader>4", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon: Navigate to 4" })
      vim.keymap.set("n", "<leader>5", function()
        harpoon:list():select(5)
      end, { desc = "Harpoon: Navigate to 5" })
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    lazy = true,
    ft = { "http" },
    opts = {
      default_view = "headers_body",
      default_env = "local",
      environment_scope = "g",
    },
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { { "<leader>o", "<cmd>Outline<CR>", desc = "Outline: Toggle" } },
    opts = {
      outline_window = {
        show_relative_numbers = true,
      },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Persistence: Restore Session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Persistence: Select Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Persistence: Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Persistence: Don't Save Current Session",
      },
    },
  },
  {
    "mbbill/undotree",
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "UndoTree: Toggle" })
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Tmux Left" },
      { "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Tmux Down" },
      { "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Tmux Up" },
      { "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Tmux Right" },
      { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Tmux Previous" },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    cmd = "VenvSelect",
    ft = "python",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
        search = {
          pipenv = { command = "fd /bin/python$ ~/.local/share/virtualenvs --full-path" },
        },
      },
    },
    keys = { { "<leader>vs", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  },
}
