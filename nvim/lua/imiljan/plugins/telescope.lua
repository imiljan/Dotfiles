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
      local trouble = require("trouble.providers.telescope")

      require("telescope").setup({
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble },
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

      local builtin = require("telescope.builtin")

      -- File Pickers https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#file-pickers
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search Files" })
      vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Search Git Files" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current Word" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search by Grep" })
      vim.keymap.set("n", "<leader>sp", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end, { desc = "Search by Grep with input" })
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "Search [/] in Open Files" })

      -- Vim Pickers https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#vim-pickers
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = 'Search Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "Search Commands" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Search Resume" })

      -- Lists Picker https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#neovim-lsp-pickers
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Search Select Telescope" })

      -- TODO: Git Pickers https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#git-pickers

      -- Shortcut for searching your neovim configuration files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "Search Neovim files" })

      -- Telescope file browser
      vim.keymap.set("n", "<space>fb", function()
        require("telescope").extensions.file_browser.file_browser()
      end)
    end,
  },
}
