return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      source_selector = {
        winbar = true,
        statusline = true,
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { "node_modules", ".git", ".husky", ".idea" },
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
    })

    vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { desc = "NeoTree: Toggle" })
  end,
}
