return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvimtools/none-ls-extras.nvim" },
  config = function()
    local null_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("NoneLSLspFormatting", {})

    -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md#
    -- https://github.com/nvimtools/none-ls-extras.nvim/tree/main/lua/none-ls
    null_ls.setup({
      sources = {
        -- Formatters
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.terraform_fmt,

        -- Code Actions
        require("none-ls.code_actions.eslint_d"),

        -- Linters
        require("none-ls.diagnostics.eslint_d"),
        null_ls.builtins.diagnostics.codespell,
        require("none-ls.diagnostics.flake8"),
        null_ls.builtins.diagnostics.actionlint,
        null_ls.builtins.diagnostics.checkmake,
        null_ls.builtins.diagnostics.hadolint,
        require("none-ls.diagnostics.yamllint"),
        null_ls.builtins.diagnostics.markdownlint_cli2,
        null_ls.builtins.diagnostics.terraform_validate,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                filter = function(c)
                  return c.name == "null-ls"
                end,
                bufnr = bufnr,
              })
            end,
          })
        end
      end,
    })
  end,
}
