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
          path_display = { "truncate" },
          dynamic_preview_title = true,
          mappings = {
            i = {
              ["<C-j>"] = telescope_actions.cycle_history_next,
              ["<C-k>"] = telescope_actions.cycle_history_prev,
              ["<C-t>"] = trouble.open
            },
            n = {
              ["<C-j>"] = telescope_actions.cycle_history_next,
              ["<C-k>"] = telescope_actions.cycle_history_prev,
              ["<C-t>"] = trouble.open
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

      vim.keymap.set("n", "<C-p>", function() builtin.git_files({ use_git_root = false }) end, { desc = "Search Git Files" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search Files" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current Word" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search by Grep" })
      vim.keymap.set("n", "<leader>sp", function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end, { desc = "Search by Grep with input" })
      vim.keymap.set("n", "<leader>s/", function() builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" }) end, { desc = "Search [/] in Open Files" })

      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "Search Recent Files" })
      vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "Search Commands" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
      vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "Search Marks" })
      vim.keymap.set("n", '<leader>"',  builtin.registers, { desc = "Search Registers" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Search Resume" })

      vim.keymap.set("n", "<leader>cs", builtin.spell_suggest, { desc = "Telescope: Search Spell Suggestions" })
      vim.keymap.set("n", "<leader>/", function() builtin.current_buffer_fuzzy_find( require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })) end, { desc = "[/] Fuzzily search in current buffer" })

      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Search Select Telescope" })

      -- TODO: Git Pickers https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#git-pickers

      vim.keymap.set("n", "<leader>sn", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Search Neovim files" })

      -- Extensions
      vim.keymap.set("n", "<space>fb", function() require("telescope").extensions.file_browser.file_browser() end, { desc = "Telescope: FileBrowser" })
      vim.keymap.set("n", "<space>fa", function() require("telescope").extensions.harpoon.marks() end, { desc = "Telescope: Harpoon" })
    end,
  },
}
