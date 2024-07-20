return {
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
    { "<leader>S", group = "Spectre" },
    { "<leader>a", group = "Harpoon" },
    { "<leader>b", group = "Bufferline" },
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Document/Debug/Delete" },
    { "<leader>f", group = "Telescope File Browser" },
    { "<leader>h", group = "Hunks (Git)" },
    { "<leader>ht", group = "Hunks toggle (Git)" },
    { "<leader>l", group = "Location list/LazyGit" },
    { "<leader>m", group = "Harpoon" },
    { "<leader>o", group = "Outline" },
    { "<leader>q", group = "Quickfix list / Persistence" },
    { "<leader>r", group = "Rename" },
    { "<leader>s", group = "Search" },
    { "<leader>t", group = "Test/Tab" },
    { "<leader>u", group = "UndoTree" },
    { "<leader>w", group = "LSP Workspace search" },
    { "<leader>x", group = "Trouble" },
    { "<leader>z", group = "Zen" },
    { "[", group = "Previous ..." },
    { "]", group = "Next ..." },

    { "<leader>h", desc = "Hunks (Git)", mode = "v" },
  },
}
