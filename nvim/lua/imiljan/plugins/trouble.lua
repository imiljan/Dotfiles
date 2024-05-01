return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = { use_diagnostic_signs = true },
  -- stylua: ignore
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Trouble: Diagnostics" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Trouble: Buffer Diagnostics" },

    { "<leader>xr", "<cmd>Trouble lsp_references<cr>",                            desc = "Trouble: LSP References" },
    { "<leader>xL", "<cmd>Trouble lsp toggle focus=false<cr>",                    desc = "Trouble: LSP Definitions / references / ..." }, -- LSP definitions, references, implementations, type definitions, and declarations

    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
    { "<leader>xS", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP references/definitions/... (Trouble)" },

    { "<leader>xt", "<cmd>Trouble telescope toggle<cr>",                          desc = "Trouble: Telescope" },

    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                             desc = "Trouble: Quickfix List" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                            desc = "Trouble: Location List" },
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
