return {
  "folke/todo-comments.nvim",
  event = "VimEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  -- stylua: ignore
  keys = {
    { "<leader>qt", "<cmd>TodoQuickFix<cr>",                          desc = "QuickFix: Todo" },
    { "<leader>qT", "<cmd>TodoQuickFix keywords=TODO,FIX,FIXME<cr>",  desc = "QuickFix: Todo/Fix/Fixme" },

    { "<leader>lt", "<cmd>TodoLocList<cr>",                           desc = "LocationList: Todo" },
    { "<leader>lT", "<cmd>TodoLocList keywords=TODO,FIX,FIXME<cr>",   desc = "LocationList: Todo/Fix/Fixm" },

    { "<leader>xt", "<cmd>TodoTrouble<cr>",                           desc = "Trouble: Todo" },
    { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",   desc = "Trouble: Todo/Fix/Fixme" },

    { "<leader>st", "<cmd>TodoTelescope<cr>",                         desc = "SEARCH: Todo" },
    { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "SEARCH: Todo/Fix/Fixme" },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous Todo Comment",
    },
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next Todo Comment",
    },
  },
}
