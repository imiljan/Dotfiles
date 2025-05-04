local function ts_code_action(action)
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { action },
      diagnostics = {},
    },
  })
end
-- https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#features

-- despite the name, fixes a couple of specific issues: unreachable code, await in non-async functions, incorrectly implemented interface
vim.keymap.set("n", "<leader>cA", function()
  ts_code_action("source.fixAll.ts")
end, { desc = "LSP TS: Fix all" })

-- removes declared but unused variables
vim.keymap.set("n", "<leader>cU", function()
  ts_code_action("source.removeUnused.ts")
end, { desc = "LSP TS: Remove Unused Variables" })

-- adds imports for used but not imported symbols
vim.keymap.set("n", "<leader>cm", function()
  ts_code_action("source.addMissingImports.ts")
end, { desc = "LSP TS: Add Missing Imports" })

-- removes unused imports
vim.keymap.set("n", "<leader>cu", function()
  ts_code_action("source.removeUnusedImports.ts")
end, { desc = "LSP TS: Remove Unused Imports" })

-- sorts imports
vim.keymap.set("n", "<leader>cs", function()
  ts_code_action("source.sortImports.ts")
end, { desc = "LSP TS: Sort Imports" })

-- organizes and removes unused imports
vim.keymap.set("n", "<leader>co", function()
  ts_code_action("source.organizeImports.ts")
end, { desc = "LSP TS: Organize Imports" })
