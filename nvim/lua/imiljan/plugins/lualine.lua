return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/trouble.nvim" },
  config = function()
    local trouble = require("trouble")
    local symbols = trouble.statusline({
      mode = "lsp_document_symbols",
      groups = {},
      title = false,
      filter = { range = true },
      format = "{kind_icon}{symbol.name:Normal}",
      hl_group = "lualine_c_normal",
    })

    require("lualine").setup({
      options = {
        theme = "auto",
        globalstatus = true,
      },
      sections = {
        lualine_c = { { "filename", path = 1 }, { symbols.get, cond = symbols.has } },
      },
      extensions = { "neo-tree", "lazy" },
    })
  end,
}
