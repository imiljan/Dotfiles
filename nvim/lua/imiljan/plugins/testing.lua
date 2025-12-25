return {
  {
    "vim-test/vim-test",
    lazy = true,
    ft = { "typescript", "javascript" },
    dependencies = { "preservim/vimux" },
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    config = function()
      vim.cmd("let test#strategy = 'vimux'")

      vim.keymap.set("n", "<leader>tr", ":TestNearest<CR>", { desc = "Test: Run Nearest" })
      vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "Test: Run File" })
      vim.keymap.set("n", "<leader>ta", ":TestSuite<CR>", { desc = "Test: Run All" })
      vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "Test: Run Last" })
      vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { desc = "Test: Visit last test" })
      -- NOTE: For Mocha, use Debug Mocha Tests dap configuration - F5
    end,
  },
  {
    "nvim-neotest/neotest",
    lazy = true,
    ft = { "python" },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",

      -- "nvim-neotest/neotest-plenary",
      -- "adrigzr/neotest-mocha",
      "nvim-neotest/neotest-python",
      -- "nvim-neotest/neotest-vim-test",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          -- require("neotest-plenary"),
          -- require("neotest-mocha")({
          --   command = "npx mocha -r ts-node/register --",
          -- }),
          require("neotest-python"),
          --NOTE: https://github.com/nvim-neotest/neotest-vim-test?tab=readme-ov-file#issues
          -- require("neotest-vim-test")({ ignore_file_types = { "python", "vim", "lua" } }),
        },
        output = {
          enabled = true,
          open_on_run = true,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
      })
    end,
    keys = {
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Test: Run Nearest",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test: Run File",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Test: Run All",
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
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Test: Debug Nearest",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Test: Show Output",
      },
    },
  },
}
