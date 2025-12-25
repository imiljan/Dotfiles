-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jsonls
return {
  init_options = {
    provideFormatter = false,
  },
  settings = {
    json = {
      validate = { enable = true },
      schemas = require("schemastore").json.schemas(),
    },
  },
}
