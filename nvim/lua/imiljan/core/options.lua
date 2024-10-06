vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.enable_ng = 0

vim.g.python3_host_prog = "~/.venvs/.nvim-venv/bin/python"

vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"
vim.opt.scrolloff = 8

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.inccommand = "split"

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.isfname:append("@-@")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("imiljan-HighlightYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.filetype.add({
  extension = {
    ["http"] = "http",
  },
  filename = {
    [".eslintrc.json"] = "jsonc",
  },
  pattern = {
    ["tsconfig*.json"] = "jsonc",
  },
})
