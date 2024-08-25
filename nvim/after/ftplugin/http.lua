local kulala = require("kulala")

vim.keymap.set("n", "<leader>hr", kulala.run, { noremap = true, silent = true, desc = "HTTP: Run" })
vim.keymap.set("n", "<leader>hA", kulala.run_all, { noremap = true, silent = true, desc = "HTTP: Run ALL" })
vim.keymap.set("n", "<leader>hh", kulala.replay, { noremap = true, silent = true, desc = "HTTP: Replay" })
vim.keymap.set("n", "<leader>hi", kulala.inspect, { noremap = true, silent = true, desc = "HTTP: Inspect" })
vim.keymap.set("n", "<leader>hI", kulala.show_stats, { noremap = true, silent = true, desc = "HTTP: Show Stats" })
vim.keymap.set("n", "<leader>hS", kulala.scratchpad, { noremap = true, silent = true, desc = "HTTP: Scratchpad" })
vim.keymap.set("n", "<leader>hc", kulala.copy, { noremap = true, silent = true, desc = "HTTP: Copy" })
vim.keymap.set("n", "<leader>hp", kulala.from_curl, { noremap = true, silent = true, desc = "HTTP: Copy" })
vim.keymap.set("n", "<leader>hq", kulala.close, { noremap = true, silent = true, desc = "HTTP: Close" })
vim.keymap.set("n", "<leader>ht", kulala.toggle_view, { noremap = true, silent = true, desc = "HTTP: Toggle View" })
vim.keymap.set("n", "<leader>hs", kulala.search, { noremap = true, silent = true, desc = "HTTP: Search" })
vim.keymap.set("n", "<leader>he", kulala.set_selected_env, { noremap = true, silent = true, desc = "HTTP: Select env" })

vim.keymap.set("n", "[h", kulala.jump_prev, { noremap = true, silent = true, desc = "HTTP: Prev" })
vim.keymap.set("n", "]h", kulala.jump_next, { noremap = true, silent = true, desc = "HTTP: Next" })

vim.keymap.set("n", "<leader>hC", kulala.scripts_clear_global, { noremap = true, silent = true, desc = "HTTP: Clear global" })

vim.keymap.set("n", "<leader>hg", function()
  vim.ui.input({ prompt = "HTTP name >" }, function(input)
    local builtin = require("telescope.builtin")
    builtin.grep_string({
      search = "@name " .. input,
      additional_args = { "--glob=*.http" },
    })
  end)
end, { noremap = true, silent = true, desc = "HTTP: Grep by name" })
