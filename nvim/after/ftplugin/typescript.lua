-- https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#features

-- despite the name, fixes a couple of specific issues: unreachable code, await in non-async functions, incorrectly implemented interface
vim.keymap.set("n", "<leader>cD", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.fixAll.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Fix all" })

-- removes declared but unused variables
vim.keymap.set("n", "<leader>cU", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.removeUnused.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Remove Unused" })

-- adds imports for used but not imported symbols
vim.keymap.set("n", "<leader>cm", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.addMissingImports.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Add Missing Imports" })

-- removes unused imports
vim.keymap.set("n", "<leader>cu", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.removeUnusedImports.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Remove Unused Imports" })

-- sorts imports
vim.keymap.set("n", "<leader>cS", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.sortImports.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Sort Imports" })

-- organizes and removes unused imports
vim.keymap.set("n", "<leader>co", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports.ts" },
      diagnostics = {},
    },
  })
end, { desc = "LSP TS: Organize Imports" })
