return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup()
    wk.register({
      ["<leader>S"] = { name = "Spectre" },

      ["<leader>b"] = { name = "Bufferline" },
      ["<leader>c"] = { name = "Code" },
      ["<leader>d"] = { name = "Document/Debug/Delete" },
      ["<leader>f"] = { name = "Telescope File Browser" },
      ["<leader>h"] = { name = "Hunks (Git)" },
      ["<leader>ht"] = { name = "Hunks toggle (Git)" },
      ["<leader>l"] = { name = "Location list/LazyGit" },
      ["<leader>m"] = { name = "Harpoon" },
      ["<leader>o"] = { name = "Outline" },
      ["<leader>q"] = { name = "Quickfix list / Persistence" },
      ["<leader>r"] = { name = "Rename" },
      ["<leader>s"] = { name = "Search" },
      ["<leader>t"] = { name = "Test/Tab" },
      ["<leader>u"] = { name = "UndoTree" },
      ["<leader>w"] = { name = "LSP Workspace search"  },
      ["<leader>x"] = { name = "Trouble" },
      ["<leader>z"] = { name = "Zen" },

      ["["] = { name = "Previous ..." },
      ["]"] = { name = "Next ..." },
    })

    wk.register({
      ["<leader>h"] = { "Hunks (Git)" },
    }, { mode = "v" })
  end,
}
