return {
  settings = {
    pyright = { -- https://microsoft.github.io/pyright/#/settings?id=pyright-settings
      --     disableLanguageServices = false,
      disableOrganizeImports = true, -- Using Ruff's import organizer
      --     disableTaggedHints = false,
      --     openFilesOnly = false,
      --     useLibraryCodeForTypes = false,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        -- ignore = { "*" },
      },
    },
  },
}
