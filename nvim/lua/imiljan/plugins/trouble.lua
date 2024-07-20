return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>xx", "<cmd>Trouble<cr>",                                                desc = "Trouble" },

    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                desc = "Trouble: Buffer Diagnostics" },
    { "<leader>xD", "<cmd>Trouble diagnostics toggle<cr>",                             desc = "Trouble: Diagnostics" },

    { "<leader>xr", "<cmd>Trouble lsp_references focus=false<cr>",                     desc = "Trouble: LSP References" },
    { "<leader>xL", "<cmd>Trouble lsp toggle focus=false<cr>",                         desc = "Trouble: LSP", },

    { "<leader>xs", "<cmd>Trouble symbols toggle win.position=bottom focus=false<cr>", desc = "Trouble: Symbols" },

    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                                  desc = "Trouble: Quickfix List" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                                 desc = "Trouble: Location List" },
    {
      "[x",
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
      desc = "Previous Trouble/Quickfix Item",
    },
    {
      "]x",
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
      desc = "Next Trouble/Quickfix Item",
    },
  },
}
