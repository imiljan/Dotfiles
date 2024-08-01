-- https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#features

vim.keymap.set("n", "<leader>cD", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.fixAll.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Fix all" })

vim.keymap.set("n", "<leader>cu", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.removeUnused.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Remove Unused" })

vim.keymap.set("n", "<leader>cm", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.addMissingImports.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Add Missing Imports" })

vim.keymap.set("n", "<leader>cx", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.removeUnusedImports.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Remove Unused Imports" })

vim.keymap.set("n", "<leader>cS", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.sortImports.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Sort Imports" })

vim.keymap.set("n", "<leader>co", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Organize Imports" })
