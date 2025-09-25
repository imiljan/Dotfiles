-- vim.keymap.set("n", "<leader>n", vim.cmd.Ex, { desc = "Netrw" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Remove highlight" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable EX mode on Q" })
vim.keymap.set("n", "<F1>", "<nop>", { desc = "Disable Help" })
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<cr>", { desc = "TmuxSessionizer" })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux-sessionizer<cr>", { desc = "TmuxSessionizer" })
vim.keymap.set("n", "<C-b>", "<cmd>silent !tmux-chooser<cr>", { desc = "TmuxChooser" })

vim.keymap.set("n", "<up>", "<cmd>resize +5<cr>", { desc = "Resize +" })
vim.keymap.set("n", "<down>", "<cmd>resize -5<cr>", { desc = "Resize -" })
vim.keymap.set("n", "<right>", "<cmd>vertical resize +5<cr>", { desc = "Resize vertical +" })
vim.keymap.set("n", "<left>", "<cmd>vertical resize -5<cr>", { desc = "Resize vertical -" })

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move highlighted line down" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move highlighted line up" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent stay in visual" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent stay in visual" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Keeps cursor in the same place after appending" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Better half page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Better half page up" })
vim.keymap.set("n", "n", "nzz", { desc = "Better next search" })
vim.keymap.set("n", "N", "Nzz", { desc = "Better previous search" })

vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })
vim.keymap.set("x", "<leader>P", [["_dP]], { desc = "Paste without changing the pastebuffer" })
vim.keymap.set("n", "x", '"_x', { desc = "Delete single char without reg" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>dd", [["_d]], { desc = "Delete to void" })

vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", { desc = "Toggle wrap" })

vim.keymap.set("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace current word" })

-- Tabs
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<cr>", { desc = "TAB: open new" })
vim.keymap.set("n", "<leader>tq", "<cmd>tabclose<cr>", { desc = "TAB: close current" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<cr>", { desc = "TAB: go to next" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<cr>", { desc = "TAB: go to prev" })

-- Loclist
vim.keymap.set("n", "]l", "<cmd>lnext<cr>", { desc = "LocationList: next" })
vim.keymap.set("n", "[l", "<cmd>lprev<cr>", { desc = "LocationList: prev" })

-- Quickfix
vim.keymap.set("n", "<leader>qo", "<cmd>copen<cr>", { desc = "QuickFix: open" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "QuickFix: close" })
