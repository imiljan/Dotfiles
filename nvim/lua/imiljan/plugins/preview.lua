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
    "vinnymeller/swagger-preview.nvim",
    cmd = { "SwaggerPreviewToggle", "SwaggerPreview", "SwaggerPreviewStop" },
    build = "npm install -g swagger-ui-watcher",
    config = true,
  },
}
