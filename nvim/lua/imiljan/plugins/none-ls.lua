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
        -- Lua
        null_ls.builtins.formatting.stylua,

        -- JS/TS
        -- require("none-ls.diagnostics.eslint"),
        require("none-ls.diagnostics.eslint_d"),

        -- require("none-ls.code_actions.eslint"),
        require("none-ls.code_actions.eslint_d"),

        -- null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.prettierd,

        -- Python
        require("none-ls.diagnostics.flake8"),
        -- null_ls.builtins.diagnostics.mypy,
        -- require("none-ls.diagnostics.ruff"),

        -- require("none-ls.formatting.autopep8"),
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,

        -- JSON
        require("none-ls.formatting.jq"),

        -- Codespell finds common misspellings in text files.
        null_ls.builtins.diagnostics.codespell,

        -- GH Actions
        null_ls.builtins.diagnostics.actionlint,

        -- Makefiles
        null_ls.builtins.diagnostics.checkmake,

        -- A smarter Dockerfile linter that helps you build best practice Docker images.
        null_ls.builtins.diagnostics.hadolint,

        -- YML
        require("none-ls.diagnostics.yamllint"),

        -- MD
        null_ls.builtins.diagnostics.markdownlint_cli2,

        -- Terraform
        null_ls.builtins.formatting.terraform_fmt,
        null_ls.builtins.diagnostics.terraform_validate,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            -- pattern = { "*.ts", "*.js", "*.py" },
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
