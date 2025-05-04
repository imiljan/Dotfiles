vim.filetype.add({
  extension = {
    ["http"] = "http",
  },
  filename = {
    [".eslintrc.json"] = "jsonc",
  },
  pattern = {
    ["tsconfig*.json"] = "jsonc",
    [".*/%.vscode/.*%.json"] = "jsonc",
  },
})
