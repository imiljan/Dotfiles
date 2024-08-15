vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove highlight" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable EX mode on Q" })
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<F1>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "TmuxSessionizer" })

vim.keymap.set("n", "<C-w><up>", "<cmd>resize +5<CR>", { desc = "Resize +" })
vim.keymap.set("n", "<C-w><down>", "<cmd>resize -5<CR>", { desc = "Resize -" })
vim.keymap.set("n", "<C-w><right>", "<cmd>vertical resize +5<CR>", { desc = "Resize vertical +" })
vim.keymap.set("n", "<C-w><left>", "<cmd>vertical resize -5<CR>", { desc = "Resize vertical -" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlighted line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlighted line up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Keeps cursor in the same place after appending" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Better half page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Better half page up" })
vim.keymap.set("n", "n", "nzz", { desc = "Better next search" })
vim.keymap.set("n", "N", "Nzz", { desc = "Better previous search" })

vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })
vim.keymap.set("x", "<leader>P", [["_dP]], { desc = "Paste without changing the pastebuffer" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipbloadr" })

vim.keymap.set({ "n", "v" }, "<leader>dd", [["_d]], { desc = "Delete to void" })

vim.keymap.set(
  "n",
  "<leader>rr",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace current word" }
)

vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "TAB: open new" })
vim.keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>", { desc = "TAB: close current" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "TAB: go to next" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "TAB: go to prev" })

vim.keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { desc = "QuickFix: open" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "QuickFix: close" })
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>zz", { desc = "QuickFix: next" })
vim.keymap.set("n", "<leader>qp", "<cmd>cprev<CR>zz", { desc = "QuickFix: prev" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "QuickFix: next" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "QuickFix: prev" })

vim.keymap.set("n", "<leader>lo", "<cmd>lopen<CR>", { desc = "LocationList: open" })
vim.keymap.set("n", "<leader>lc", "<cmd>lclose<CR>", { desc = "LocationList: close" })
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz", { desc = "LocationList: next" })
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz", { desc = "LocationList: prev" })
vim.keymap.set("n", "]l", "<cmd>lnext<CR>zz", { desc = "LocationList: next" })
vim.keymap.set("n", "[l", "<cmd>lprev<CR>zz", { desc = "LocationList: prev" })
