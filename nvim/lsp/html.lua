-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#html
return {
  filetypes = { "html" },
  init_options = {
    provideFormatter = false,
  },
}
