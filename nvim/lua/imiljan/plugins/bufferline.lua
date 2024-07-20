return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      mode = "tabs",
      separator_style = "slant",
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          separator = true,
          text_align = "left",
        },
      },
    },
  },
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "BufLine: Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "BufLine: Delete Non-Pinned Buffers" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "BufLine: Delete Other Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "BufLine: Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "BufLine: Delete Buffers to the Left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "BufLine: Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "BufLine: Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "BufLine: Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "BufLine: Next Buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "BufLine: Move buffer prev" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "BufLine: Move buffer next" },
  },
}
