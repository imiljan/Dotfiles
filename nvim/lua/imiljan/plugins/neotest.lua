return {
  "nvim-neotest/neotest",
  dependencies = {
    "vim-test/vim-test",
    "preservim/vimux",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-vim-test",
  },
  module = { "neotest", "neotest.async" },
  cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
  opts = {
    status = { virtual_text = true },
    output = { open_on_run = true },
  },
  config = function()
    vim.cmd("let test#strategy = 'vimux'") -- vim-test

    require("neotest").setup({
      adapters = {
        require("neotest-plenary"),
        require("neotest-python"),
        require("neotest-vim-test")({
          ignore_file_types = { "python", "vim", "lua" },
        }),
      },
    })
  end,
  keys = {
    -- { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: Run File", },
    {
      "<leader>tr",
      function()
        require("neotest").run.run()
      end,
      desc = "Test: Run Nearest",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Test: Run Last",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Test: Toggle Summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Test: Show Output",
    },
    {
      "<leader>tO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Test: Toggle Output Panel",
    },
    {
      "<leader>tS",
      function()
        require("neotest").run.stop()
      end,
      desc = "Test: Stop",
    },
    --  For Mocha, use Debug Mocha Tests dap configuration
    {
      "<leader>td",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Test: Debug Nearest",
    },
  },
}
