-- return {
-- 	"vim-test/vim-test",
-- 	dependencies = {
-- 		"preservim/vimux",
-- 	},
--
-- 	vim.keymap.set("n", "<leader>t", ":TestNearest<CR>"),
-- 	vim.keymap.set("n", "<leader>T", ":TestFile<CR>"),
-- 	vim.keymap.set("n", "<leader>a,", ":TestSuite<CR>"),
-- 	vim.keymap.set("n", "<leader>l", ":TestLast<CR>"),
-- 	vim.keymap.set("n", "<leader>g", ":TestVisit<CR>"),
-- 	vim.cmd("let test#strategy = 'vimux'"),
-- }

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
    -- "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-vim-test",
  },
  module = { "neotest", "neotest.async" },
  cmd = {
    "TestNearest",
    "TestFile",
    "TestSuite",
    "TestLast",
    "TestVisit",
  },
  opts = {
    status = { virtual_text = true },
    output = { open_on_run = true },
  },
  config = function()
    vim.cmd("let test#strategy = 'vimux'") -- vim-test

    require("neotest").setup({
      adapters = {
        require("neotest-plenary"),
        -- require("neotest-python"), -- https://www.lazyvim.org/extras/lang/python
        require("neotest-vim-test")({
          ignore_file_types = { "python", "vim", "lua" },
        }),
      },
    })
  end,
  -- stylua: ignore
  keys = {
    { "<leader>Tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File" },
    { "<leader>TT", function() require("neotest").run.run(vim.uv.cwd()) end,                            desc = "Run All Test Files" },
    { "<leader>Tr", function() require("neotest").run.run() end,                                        desc = "Run Nearest" },
    { "<leader>Tl", function() require("neotest").run.run_last() end,                                   desc = "Run Last" },
    { "<leader>Ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary" },
    { "<leader>To", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    { "<leader>TO", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel" },
    { "<leader>TS", function() require("neotest").run.stop() end,                                       desc = "Stop" },

    --  TODO: Make it work with TS and Mocha!
    -- { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,                    desc = "Debug Nearest" },
  },
}
