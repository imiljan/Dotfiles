return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      {
        "<leader>Ss",
        function()
          require("spectre").toggle()
        end,
        desc = "Spectre: Toggle ",
      },
      {
        "<leader>Sr",
        function()
          require("spectre").open()
        end,
        desc = "Spectre: Replace in Files",
      },
      {
        "<leader>Sw",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        desc = "Spectre: Search current word",
      },
      {
        "<leader>Sw",
        function()
          require("spectre").open_visual()
        end,
        desc = "Spectre: Search current word",
        mode = { "v" },
      },
      {
        "<leader>Sp",
        function()
          require("spectre").open_file_search({ select_word = true })
        end,
        desc = "Spectre: Search on current file",
      },
    },
  },
}
