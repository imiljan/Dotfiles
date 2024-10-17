local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = "imiljan.plugins", -- Plugin Spec https://lazy.folke.io/spec
  install = { colorscheme = { "tokyonight-night", "habamax" }, missing = true },
  ui = {
    border = "rounded",
  },
  checker = {
    enabled = false,
    concurrency = nil,
    notify = true,
    frequency = 86400,
    check_pinned = false,
  },
  change_detection = { notify = false },
  rocks = {
    enabled = false,
    hererocks = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
