-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#eslint
return {
  -- https://github.com/microsoft/vscode-eslint/blob/55871979d7af184bf09af491b6ea35ebd56822cf/server/src/eslintServer.ts#L216-L229
  -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/eslint.lua#L51
  settings = {
    validate = "on",
    packageManager = vim.NIL,
    codeAction = {
      disableRuleComment = { enable = true, location = "separateLine" },
      showDocumentation = { enable = true },
    },
    codeActionOnSave = { enable = false, mode = "all" },
    format = false,
    quiet = false,
    onIgnoredFiles = "off",
    rulesCustomizations = {},
    run = "onSave",
    nodePath = nil,

    useESLintClass = false,
    experimental = { useFlatConfig = false },
    problems = { shortenToSingleLine = false },
    -- workingDirectory = { mode = "location" },
    workingDirectory = { mode = "auto" },
  },
}
