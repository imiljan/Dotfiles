return {
  -- root_dir = function(filename, bufnr) end,
  -- name = "",
  -- filetypes = {},
  -- autostart = true,
  -- single_file_support = nil,
  -- on_new_config = function(new_config, new_root_dir) end,
  -- capabilities = {},
  -- cmd = {},
  -- handlers = {},
  -- init_options = {
  --   -- https://neovim.io/doc/user/lsp.html#vim.lsp.ClientConfig
  --   -- {init_options} (table) Values to pass in the initialization request as initializationOptions.
  --   -- See initialize in the LSP spec.
  -- },
  -- on_attach = {},
  settings = { -- https://luals.github.io/wiki/settings/
    -- {settings} (table) Map with language server specific settings.
    -- These are returned to the language server if requested via workspace/configuration.
    -- Keys are case-sensitive.
    --
    -- In most cases, you only want to change/check settings...
    Lua = {
      -- addonManager = {},
      completion = { callSnippet = "Replace" },
      -- diagnostics = { disable = { "missing-fields" } },
      doc = {
        privateName = { "^_" },
      },
      format = { enable = false },
      hint = {
        enable = true,
        arrayIndex = "Disable",
        paramName = "Disable",
        paramType = true,
        semicolon = "Disable",
        setType = false,
      },
      -- hover = {},
      -- misc = {},
      runtime = {
        version = "LuaJIT",
      },
      -- semantic = {},
      -- spell = {},
      -- telemetry = {},
      -- type = {},
      -- window = {},
      workspace = {
        checkThirdParty = false,
        library = {
          vim.api.nvim_get_runtime_file("", true),
          "${3rd}/luv/library",
        },
      },
    },
  },
}
