return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason-nvim-dap.nvim",
      "williamboman/mason-null-ls.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "folke/neodev.nvim",
      {
        "j-hui/fidget.nvim",
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },
    },
    config = function()
      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      require("neodev").setup({})

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local vmap = function(keys, func, desc)
            vim.keymap.set("v", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local imap = function(keys, func, desc)
            vim.keymap.set("i", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local builtin = require("telescope.builtin")

          -- Neovim LSP Pickers - Telescope https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#neovim-lsp-pickers
          map("gd", builtin.lsp_definitions, "goto definition")
          map("gr", builtin.lsp_references, "goto references")
          map("gI", builtin.lsp_implementations, "goto Implementation")
          map("gD", vim.lsp.buf.declaration, "goto Declaration")
          map("K", vim.lsp.buf.hover, "Hover Documentation")

          map("<leader>D", builtin.lsp_type_definitions, "Type Definition")
          map("<leader>ds", builtin.lsp_document_symbols, "document symbols")
          map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "dynamic workspace symbols")
          map("<leader>wS", function()
            builtin.lsp_workspace_symbols({ query = vim.fn.input("Workspace Symbols > ") })
          end, "workspace symbols")
          map("<leader>sd", builtin.diagnostics, "search diagnostics")

          map("<leader>fr", vim.lsp.buf.references, "references")
          map("<leader>rn", vim.lsp.buf.rename, "rename")
          map("<leader>ca", vim.lsp.buf.code_action, "code action")
          vmap("<leader>ca", vim.lsp.buf.code_action, "code action")
          map("<leader>ff", vim.lsp.buf.format, "format file")

          -- Diagnostic keymaps
          map("[d", vim.diagnostic.goto_prev, "Go to previous Diagnostic message")
          map("]d", vim.diagnostic.goto_next, "Go to next Diagnostic message")
          map("<leader>e", vim.diagnostic.open_float, "Show diagnostic Error messages")
          map("<leader>qq", vim.diagnostic.setqflist, "Open diagnostic QuickFix list")
          map("<leader>ll", vim.diagnostic.setloclist, "Open diagnostic Location list")

          imap("<C-i>", vim.lsp.buf.signature_help, "Signature Help")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      -- :help lspconfig-setup
      -- https://neovim.io/doc/user/lsp.html
      local servers = {
        pyright = {},

        -- https://www.lazyvim.org/extras/lang/typescript
        tsserver = {
          -- {init_options} (table) Values to pass in the initialization request as initializationOptions. See initialize in the LSP spec.
          init_options = {  -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#initializationoptions
            preferences = { -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#preferences-options
              -- Defaults
              --  disableSuggestions = false,
              --
              -- 	quotePreference = "auto",
              --
              --  includeCompletionsForModuleExports = true,
              -- 	includeCompletionsForImportStatements = true,
              -- 	includeCompletionsWithSnippetText = true,
              -- 	includeCompletionsWithInsertText = true,
              -- 	includeAutomaticOptionalChainCompletions = true,
              -- 	includeCompletionsWithClassMemberSnippets = true,
              -- 	includeCompletionsWithObjectLiteralMethodSnippets = true,
              --
              -- 	useLabelDetailsInCompletionEntries = true,
              -- 	allowIncompleteCompletions = true,
              -- 	importModuleSpecifierPreference = "shortest",
              -- 	importModuleSpecifierEnding = "auto",
              -- 	allowTextChangesInNewFiles = true,
              --
              --  Some orgImprot preferences, check the docs...
              --
              -- 	providePrefixAndSuffixTextForRename = true,
              -- 	provideRefactorNotApplicableReason = true,
              -- 	allowRenameOfImportPath = true,
              --
              interactiveInlayHints = true,
              -- 	jsxAttributeCompletionStyle = "auto",
              -- 	displayPartsForJSDoc = true,
              -- 	excludeLibrarySymbolsInNavTo = true,
              -- 	generateReturnInDocTemplate = true,

              -- InlayHints - Above https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#workspacedidchangeconfiguration
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          -- {settings} (table) Map with language server specific settings. These are returned to the language server if requested via workspace/configuration. Keys are case-sensitive.
          settings = { -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#workspacedidchangeconfiguration
            typescript = {
              -- Formatting preferences
              insertSpaceAfterCommaDelimiter = true,
              insertSpaceAfterConstructor = false,
              insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
              insertSpaceAfterKeywordsInControlFlowStatements = true,
              insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
              insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
              insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
              insertSpaceAfterSemicolonInForStatements = true,
              insertSpaceAfterTypeAssertion = false,
              insertSpaceBeforeAndAfterBinaryOperators = true,
              insertSpaceBeforeFunctionParenthesis = false,

              placeOpenBraceOnNewLineForControlBlocks = false,
              placeOpenBraceOnNewLineForFunctions = false,
              semicolons = "ignore",
              -- Inlay Hints preferences
              -- ...
              -- Code Lens preferences
              -- ...
            },
            javascript = {
              -- Formatting preferences
              insertSpaceAfterCommaDelimiter = true,
              insertSpaceAfterConstructor = false,
              insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
              insertSpaceAfterKeywordsInControlFlowStatements = true,
              insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
              insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
              insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
              insertSpaceAfterSemicolonInForStatements = true,
              insertSpaceAfterTypeAssertion = false,
              insertSpaceBeforeAndAfterBinaryOperators = true,
              insertSpaceBeforeFunctionParenthesis = false,

              placeOpenBraceOnNewLineForControlBlocks = false,
              placeOpenBraceOnNewLineForFunctions = false,
              semicolons = "ignore",
              -- Inlay Hints preferences
              -- ...
              -- Code Lens preferences
              -- ...
            },
            completions = {
              completeFunctionCalls = false,
            },
          },
          commands = { -- https://github.com/typescript-language-server/typescript-language-server/tree/master?tab=readme-ov-file#workspace-commands-workspaceexecutecommand
            OrganizeImports = {
              function()
                vim.lsp.buf.execute_command({
                  command = "_typescript.organizeImports",
                  arguments = { vim.api.nvim_buf_get_name(0) },
                  title = "TypeScript Organize Imports",
                })
              end,
              description = "Organize Imports",
            },
          },
        },

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = { disable = { "missing-fields" } },
              hint = { enable = true }, -- NeoVim >= 0.10.0
            },
          },
        },
      }

      -- local linters_and_formatters = { "stylua", "prettier", "eslint-lsp", "mypy", "ruff", "black", "isort" }

      local ensure_installed = vim.tbl_keys(servers or {})
      local linters =
      { "eslint-lsp", "eslint_d", "flake8", "codespell", "actionlint", "checkmake", "hadolint", "yamllint" }
      local formatters = { "stylua", "prettier", "prettierd", "autopep8", "isort", "jq" }
      -- js-debug-addapter installed manually, not working here
      local debuggers = { "debugpy" }
      vim.list_extend(ensure_installed, linters)
      vim.list_extend(ensure_installed, formatters)
      vim.list_extend(ensure_installed, debuggers)

      require("mason").setup()
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

            -- https://www.lazyvim.org/plugins/lsp#nvim-lspconfig
            -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
            -- Be aware that you also will need to properly configure your LSP server to
            -- provide the inlay hints.
            server.inlay_hints = {
              enabled = true,
            }

            -- https://www.lazyvim.org/plugins/lsp#nvim-lspconfig
            -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
            -- Be aware that you also will need to properly configure your LSP server to
            -- provide the code lenses.
            server.codelens = {
              enabled = false,
            }

            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
