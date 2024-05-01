return {
  "folke/todo-comments.nvim",
  event = "VimEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  -- stylua: ignore
  keys = {
    { "]t",         function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },

    { "<leader>qt", "<cmd>TodoQuickFix<cr>",                             desc = "Todo (QuickFix)" },
    { "<leader>qT", "<cmd>TodoQuickFix keywords=TODO,FIX,FIXME<cr>",     desc = "Todo/Fix/Fixme (QuickFix)" },

    { "<leader>lt", "<cmd>TodoLocList<cr>",                              desc = "Todo (LocationList)" },
    { "<leader>lT", "<cmd>TodoLocList keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (LocationList)" },

    { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
    { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },

    { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Search Todo (Telecope)" },
    { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Search Todo/Fix/Fixme (Telecope)" },
  },
}
