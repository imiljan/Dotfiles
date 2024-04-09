return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup()
    wk.register({
      ["<leader>T"] = { name = "Test" },

      ["<leader>c"] = { name = "Code" },
      ["<leader>d"] = { name = "Document/Debug/Delete" },
      ["<leader>f"] = { name = "Telescope File Browser" },
      ["<leader>g"] = { name = "LazyGit" },
      ["<leader>h"] = { name = "Hunks (Git)" },
      ["<leader>l"] = { name = "Location list" },
      ["<leader>p"] = { name = "Prime" },
      ["<leader>q"] = { name = "Quickfix list" },
      ["<leader>r"] = { name = "Rename" },
      ["<leader>s"] = { name = "Search" },
      ["<leader>t"] = { name = "Tabs" },
      ["<leader>w"] = { name = "Workspace" },
      ["<leader>x"] = { name = "Trouble" },

      ["["] = { name = "Previous ..." },
      ["]"] = { name = "Next ..." },
    })
  end,
}
