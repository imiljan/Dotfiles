return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
      "sharkdp/fd",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope_actions = require("telescope.actions")
      local trouble = require("trouble.sources.telescope")

      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              height = 0.9,
              preview_cutoff = 120,
              prompt_position = "top",
              width = 0.8,
            },
            vertical = {
              height = 0.9,
              preview_cutoff = 40,
              prompt_position = "top",
              width = 0.8,
            },
          },
          border = true,
          path_display = { "truncate" },
          dynamic_preview_title = true,
          mappings = {
            i = {
              ["<C-j>"] = telescope_actions.cycle_history_next,
              ["<C-k>"] = telescope_actions.cycle_history_prev,
              ["<C-t>"] = trouble.open,
            },
            n = {
              ["<C-j>"] = telescope_actions.cycle_history_next,
              ["<C-k>"] = telescope_actions.cycle_history_prev,
              ["<C-t>"] = trouble.open,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          ["file_browser"] = {
            hijack_netrw = false,
          },
        },
      })

      -- Enable telescope extensions, if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
      pcall(require("telescope").load_extension, "file_browser")
      pcall(require("telescope").load_extension, "harpoon")

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<C-p>", function()
        builtin.git_files({ use_git_root = false, show_untracked = true })
      end, { desc = "SEARCH: Git Files" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "SEARCH: Files" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "SEARCH: Current Word" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "SEARCH: Grep" })

      vim.keymap.set("n", "<leader>sG", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end, { desc = "SEARCH: Grep with input" })
      vim.keymap.set("n", "<leader>sd", function()
        builtin.live_grep({ search_dirs = { vim.fn.input("Directory > ") }, prompt_title = "Live Grep in Directory" })
      end, { desc = "SEARCH: Live Grep in Directory" })

      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
      end, { desc = "SEARCH: Live Grep in Open Files" })

      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "SEARCH: Recent Files" })
      vim.keymap.set("n", '<leader>s"', builtin.registers, { desc = "SEARCH: Registers" })
      vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "SEARCH: Existing buffers" })
      vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "SEARCH: Commands" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "SEARCH: Help" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "SEARCH: Keymaps" })
      vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "SEARCH: Marks" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "SEARCH: Resume" })

      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false }))
      end, { desc = "SEARCH: in current buffer" })

      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "SEARCH: Select Telescope" })
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "SEARCH: Neovim files" })

      vim.keymap.set("n", "<leader>cs", builtin.spell_suggest, { desc = "SEARCH: Spell Suggestions" })

      -- TODO: Git Pickers https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#git-pickers

      -- Extensions
      vim.keymap.set("n", "<space>fb", function()
        require("telescope").extensions.file_browser.file_browser()
      end, { desc = "Telescope: FileBrowser" })
      vim.keymap.set("n", "<space>fa", function()
        require("telescope").extensions.harpoon.marks()
      end, { desc = "Telescope: Harpoon" })
    end,
  },
}
