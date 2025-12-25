return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      gh = { enabled = true },
      indent = {
        enabled = true,
        only_scope = true,
        only_current = true,
        animate = { enabled = false },
        scope = { enabled = true },
      },
      input = { enabled = true },
      picker = { enabled = true, ui_select = true },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      zen = {
        toggles = {
          dim = false,
          git_signs = true,
        },
      },
    },
    keys = {
      -- Top Pickers & Explorer
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      -- { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- GIT
      {
        "<leader>gBl",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git: Browse REPO (at line)",
      },
      {
        "<leader>lg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>ll",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
      },
      {
        "<leader>lL",
        function()
          Snacks.lazygit.log()
        end,
        desc = "Lazygit Log (cwd)",
      },
      -- GH
      {
        "<leader>gI",
        function()
          Snacks.picker.gh_pr()
        end,
        desc = "GitHub Pull Requests (open)",
      },

      -- Other
      {
        "<leader>zz",
        function()
          Snacks.zen({ width = 160 })
        end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>zZ",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Toggle Zoom",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
    },
  },
  {
    "stevearc/overseer.nvim",
    opts = {
      task_list = {
        default_detail = 2,
        max_width = { 600, 0.7 },
        direction = "bottom",
      },
      dap = false,
      bindings = {
        ["?"] = "ShowHelp",
        ["g?"] = "ShowHelp",
        ["<CR>"] = "RunAction",
        ["<C-e>"] = "Edit",
        ["o"] = "Open",
        ["<C-v>"] = "OpenVsplit",
        ["<C-s>"] = "OpenSplit",
        ["<C-f>"] = "OpenFloat",
        ["<C-q>"] = "OpenQuickFix",
        ["p"] = "TogglePreview",
        ["<C-l>"] = "IncreaseDetail",
        ["<C-h>"] = "DecreaseDetail",
        ["L"] = "IncreaseAllDetail",
        ["H"] = "DecreaseAllDetail",
        ["["] = "DecreaseWidth",
        ["]"] = "IncreaseWidth",
        ["{"] = "PrevTask",
        ["}"] = "NextTask",
        ["<C-u>"] = "ScrollOutputUp",
        ["<C-d>"] = "ScrollOutputDown",
        ["q"] = "Close",
      },
    },
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle task window" },
      {
        "<leader>o<",
        function()
          local overseer = require("overseer")

          local tasks = overseer.list_tasks({ recent_first = true })
          if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
          else
            overseer.run_action(tasks[1], "restart")
            overseer.open({ enter = false })
          end
        end,
        desc = "Overseer: Restart last task",
      },
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

      vim.keymap.set("n", "<leader>aA", function()
        harpoon:list():prepend()
      end, { desc = "Harpoon: Prepend file" })
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
    keys = {
      { "<leader>hr", "<cmd>lua require('kulala').run()<cr>", desc = "HTTP: Run", ft = "http" },
      -- { "<leader>hA", "<cmd>lua require('kulala').run_all()<cr>", desc = "HTTP: Run ALL", ft = "http" },
      { "<leader>hh", "<cmd>lua require('kulala').replay()<cr>", desc = "HTTP: Replay", ft = "http" },
      { "<leader>ho", "<cmd>lua require('kulala').open()<cr>", desc = "HTTP: Open", ft = "http" },
      { "<leader>hi", "<cmd>lua require('kulala').inspect()<cr>", desc = "HTTP: Inspect", ft = "http" },
      { "<leader>hI", "<cmd>lua require('kulala').show_stats()<cr>", desc = "HTTP: Show Stats", ft = "http" },
      { "<leader>hS", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "HTTP: Scratchpad", ft = "http" },
      { "<leader>hc", "<cmd>lua require('kulala').copy()<cr>", desc = "HTTP: Copy as cURL", ft = "http" },
      { "<leader>hp", "<cmd>lua require('kulala').from_curl()<cr>", desc = "HTTP: Paste from cURL", ft = "http" },
      { "<leader>hq", "<cmd>lua require('kulala').close()<cr>", desc = "HTTP: Close", ft = "http" },
      { "<leader>ht", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "HTTP: Toggle View", ft = "http" },
      { "<leader>hs", "<cmd>lua require('kulala').search()<cr>", desc = "HTTP: Search", ft = "http" },
      { "<leader>[h", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "HTTP: Prev", ft = "http" },
      { "<leader>]h", "<cmd>lua require('kulala').jump_next()<cr>", desc = "HTTP: Next", ft = "http" },
      { "<leader>hC", "<cmd>lua require('kulala').scripts_clear_global()<cr>", desc = "HTTP: Clear global", ft = "http" },
      { "<leader>hR", "<cmd>lua require('kulala').clear_cached_files()<cr>", desc = "HTTP: Clear cached files", ft = "http" },
      { "<leader>hG", "<cmd>lua require('kulala').download_graphql_schema()<cr>", desc = "HTTP: Download GQL schema", ft = "http" },
      { "<leader>he", "<cmd>lua require('kulala').set_selected_env()<cr>", desc = "HTTP: Select env", ft = "http" },
      { "<leader>hE", "<cmd>lua require('kulala').get_selected_env()<cr>", desc = "HTTP: Get env", ft = "http" },

      { "<C-Up>", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "HTTP: Prev", ft = "http" },
      { "<C-Down>", "<cmd>lua require('kulala').jump_next()<cr>", desc = "HTTP: Next", ft = "http" },
    },
    opts = {
      default_view = "headers_body",
      default_env = "local",
      environment_scope = "g",
      global_keymaps = false,
      kulala_keymaps = true,
      ui = {
        win_opts = {
          wo = {
            foldmethod = "manual",
          },
        },
      },
    },
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { { "<leader>oo", "<cmd>Outline<CR>", desc = "Outline: Toggle" } },
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
          require("persistence").select()
        end,
        desc = "Persistence: Select Session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").load()
        end,
        desc = "Persistence: Restore Session",
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
      -- { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Tmux Previous" },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
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
    keys = {
      { "<leader>vs", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
    },
  },
  { "b0o/SchemaStore.nvim", lazy = true },
}
