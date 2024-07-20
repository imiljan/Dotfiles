return {
  "linux-cultist/venv-selector.nvim",
  branch = "regexp",
  cmd = "VenvSelect",
  ft = "python",
  opts = {
    settings = {
      options = {
        notify_user_on_venv_activation = true,
      },
      search = {
        pipenv = { command = "fd /bin/python$ ~/.local/share/virtualenvs --full-path" },
      },
    },
  },
  keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
}
