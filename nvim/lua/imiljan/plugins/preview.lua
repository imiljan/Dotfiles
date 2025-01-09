return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    config = function()
      local render = require("render-markdown")
      local state = require("render-markdown.state")

      render.setup({
        file_types = { "markdown", "norg", "rmd", "org" },
        code = {
          sign = false,
          width = "block",
          right_pad = 1,
        },
        heading = {
          sign = false,
          -- icons = {},
        },
      })

      vim.keymap.set("n", "<leader>mr", function()
        if state.enabled then
          render.disable()
        else
          render.enable()
        end
      end, { desc = "Markdown: Render" })

      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown: Preview" })
    end,
  },
  {
    "vinnymeller/swagger-preview.nvim",
    cmd = { "SwaggerPreviewToggle", "SwaggerPreview", "SwaggerPreviewStop" },
    build = "npm ci",
    config = true,
  },
}
