return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason-nvim-dap.nvim",
      "williamboman/mason-null-ls.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      {
        "folke/lazydev.nvim",
        dependencies = {
          { "Bilal2453/luvit-meta", lazy = true },
        },
        ft = "lua",
        opts = {
          library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
          },
        },
      },
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
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("imiljan-LspAttach", { clear = true }),
        callback = function(e)
          local builtin = require("telescope.builtin")

          -- LSP
          vim.keymap.set("n", "gd", builtin.lsp_definitions,      { buffer = e.buf, desc = "LSP: Definitions" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration,      { buffer = e.buf, desc = "LSP: Declaration" })
          vim.keymap.set("n", "K",  vim.lsp.buf.hover,            { buffer = e.buf, desc = "LSP: Documentation" })
          vim.keymap.set("n", "gr", builtin.lsp_references,       { buffer = e.buf, desc = "LSP: References" })
          vim.keymap.set("n", "gI", builtin.lsp_implementations,  { buffer = e.buf, desc = "LSP: Implementations" })
          vim.keymap.set("n", "gT", builtin.lsp_type_definitions, { buffer = e.buf, desc = "LSP: Type Definition" })
          -- gx - in Normal mode calls vim.ui.open() on whatever is under the cursor, which shells out to your operating system’s “open” capability
          vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols,          { buffer = e.buf, desc = "LSP: Document Symbols" })
          vim.keymap.set("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, { buffer = e.buf, desc = "LSP: Dynamic Workspace Symbols" })
          vim.keymap.set("n", "<leader>wS", function() builtin.lsp_workspace_symbols({ query = vim.fn.input("Workspace Symbols > ") }) end, { buffer = e.buf, desc = "LSP: Workspace Symbols" })

          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,         { buffer = e.buf, desc = "LSP: Rename" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,    { buffer = e.buf, desc = "LSP: Code Action" })
          vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format,         { buffer = e.buf, desc = "LSP: Format File" })
          vim.keymap.set("i", "<C-S>",      vim.lsp.buf.signature_help, { buffer = e.buf, desc = "LSP: Signature Help" })

          -- Diagnostic
          vim.keymap.set("n", "<leader>wd", builtin.diagnostics,                                        { buffer = e.buf, desc = "Diagnostic: Workspace search" })
          vim.keymap.set("n", "<leader>fd", function() builtin.diagnostics({ bufnr = 0 }) end,          { buffer = e.buf, desc = "Diagnostic: document search" })
          vim.keymap.set("n", "[d",         function() vim.diagnostic.goto_prev({ float = false }) end, { buffer = e.buf, desc = "Diagnostic: Go to previous message" })
          vim.keymap.set("n", "]d",         function() vim.diagnostic.goto_next({ float = false }) end, { buffer = e.buf, desc = "Diagnostic: Go to next message" })
          vim.keymap.set("n", "<C-W>d",     vim.diagnostic.open_float,                                  { buffer = e.buf, desc = "Diagnostic: Show messages" })
          vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float,                                  { buffer = e.buf, desc = "Diagnostic: Show messages" })
          vim.keymap.set("n", "<leader>qq", vim.diagnostic.setqflist,                                   { buffer = e.buf, desc = "Diagnostic: Open QuickFix list" })
          vim.keymap.set("n", "<leader>ll", vim.diagnostic.setloclist,                                  { buffer = e.buf, desc = "Diagnostic: Open Location list" })

          -- For list of capabilities
          -- :lua =vim.lsp.get_active_clients()[1].server_capabilities
          local client = vim.lsp.get_client_by_id(e.data.client_id)

          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.keymap.set("n", "<leader>lh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end, { buffer = e.buf, desc = "LSP: Toggle Inlay Hints" } )
          end

          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("imiljan-LspHighlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = e.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = e.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("imiljan-LspDetach", { clear = true }),
              callback = function(e2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "imiljan-LspHighlight", buffer = e2.buf })
              end,
            })
          end

          if client and client.name == 'tsserver' then
            client.server_capabilities.documentFormattingProvider = false

            -- vim.keymap.set("n", "g...", function ()
            --   local params = vim.lsp.util.make_position_params()
            --   vim.lsp.buf.execute_command({
            --     command = "_typescript.goToSourceDefinition",
            --     arguments = { params.textDocument.uri, params.position },
            --     open = true,
            --     title = "TypeScript Organize Imports",
            --   })
            -- end,{ buffer = e.buf, desc = "LSP TS: Goto Source Definition" })

            vim.keymap.set("n", "gR", function ()
              vim.lsp.buf.execute_command({
                command = "_typescript.findAllFileReferences",
                arguments = { vim.uri_from_bufnr(0) },
                open = true,
                title = "TypeScript Find All File References",
              })
            end, { buffer = e.buf, desc = "LSP TS: File References" })

            vim.keymap.set("n", "<leader>co", function ()
              vim.lsp.buf.execute_command({
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
                title = "TypeScript Organize Imports",
              })
            end, { buffer = e.buf, desc = "LSP TS: Organize Imports" })

            vim.keymap.set("n", "<leader>cm", function ()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.addMissingImports.ts" },
                  diagnostics = {},
                },
              })
            end, { desc = "LSP TS: Add Missiong Imports" })

            vim.keymap.set("n", "<leader>cu", function ()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnused.ts" },
                  diagnostics = {},
                },
              })
            end, { desc = "LSP TS: Remove Unused Imports" })

            vim.keymap.set("n", "<leader>cD", function ()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.fixAll.ts" },
                  diagnostics = {},
                },
              })
            end, { desc = "LSP TS: Fix all diagnostics" })
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
          init_options = { -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#initializationoptions
            preferences = { -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#preferences-options
              --  Defaults
              -- autoImportFileExcludePatterns = [],
              -- disableSuggestions = false,

              -- quotePreference = "auto",

              -- includeCompletionsForModuleExports = true,
              -- includeCompletionsForImportStatements = true,
              -- includeCompletionsWithSnippetText = true,
              -- includeCompletionsWithInsertText = true,
              -- includeAutomaticOptionalChainCompletions = true,
              -- includeCompletionsWithClassMemberSnippets = true,
              -- includeCompletionsWithObjectLiteralMethodSnippets = true,

              -- useLabelDetailsInCompletionEntries = true,
              -- allowIncompleteCompletions = true,
              -- importModuleSpecifierPreference = "shortest",
              -- importModuleSpecifierEnding = "auto",
              -- allowTextChangesInNewFiles = true,
              -- lazyConfiguredProjectsFromExternalProject = false,

              -- organizeImportsIgnoreCase = "auto",
              -- organizeImportsCollation = "ordinal",
              -- organizeImportsCollationLocale = "en",
              -- organizeImportsNumericCollation = false,
              -- organizeImportsAccentCollation = true,
              -- organizeImportsCaseFirst = false,

              -- providePrefixAndSuffixTextForRename = true,
              -- provideRefactorNotApplicableReason = true,
              -- allowRenameOfImportPath = true,
              -- includePackageJsonAutoImports = "auto",

              interactiveInlayHints = true,
              -- jsxAttributeCompletionStyle = "auto",
              -- displayPartsForJSDoc = true,
              -- excludeLibrarySymbolsInNavTo = true,
              -- generateReturnInDocTemplate = true,

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
          -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#workspacedidchangeconfiguration
          settings = {
            typescript = {
              -- Formatting preferences
              format = {
                insertSpaceAfterCommaDelimiter = true,
                insertSpaceAfterConstructor = false,
                insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
                insertSpaceAfterKeywordsInControlFlowStatements = true,
                insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
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
                semicolons = "ignore"
              },
              -- Inlay Hints preferences
              -- ...
              -- Code Lens preferences
              -- ...
              completions = {
                completeFunctionCalls = false,
              },
              -- diagnostics = {
              --   ignoredCodes = {}
              -- }
            },
            javascript = {
              -- Formatting preferences
              format = {
                insertSpaceAfterCommaDelimiter = true,
                insertSpaceAfterConstructor = false,
                insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
                insertSpaceAfterKeywordsInControlFlowStatements = true,
                insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
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
                semicolons = "ignore"
              }
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

        angularls = {
          root_dir = require("lspconfig.util").root_pattern("angular.json", "project.json"),
        },

        bashls = {},
        terraformls = {},
        dockerls = {},
        docker_compose_language_service = {},
        marksman = {},

        lua_ls = {
          -- cmd = {... },
          -- filetypes = { ... },
          -- capabilities = { ... },
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              codeLens = { enable = true },
              completion = { callSnippet = "Replace" },
              -- diagnostics = { disable = { "missing-fields" } },
              doc = { privateName = { "^_" } },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable"
              },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      local linters = { "eslint_d", "flake8", "codespell", "actionlint", "checkmake", "hadolint", "yamllint", "markdownlint_cli2" }
      local formatters = { "stylua", "prettierd", "black", "isort", "jq" }
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
            server.inlay_hints = { enabled = true }
            server.codelens = { enabled = false }

            if server_name == "tsserver" then
              vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = { "*.ts" },
                desc = "TypeScript - On Save",
                group = vim.api.nvim_create_augroup("imiljan-OrganizeImports", { clear = true }),
                callback = function()
                  print('Organize Imports')
                  vim.lsp.buf.execute_command({
                    command = "_typescript.organizeImports",
                    arguments = { vim.api.nvim_buf_get_name(0) },
                    title = "TypeScript Organize Imports",
                  })
                end,
              })
            end

            -- vim.api.nvim_create_autocmd("BufWritePre", {
            --   pattern = { "*.ts" },
            --   desc = "TypeScript - On Save Prettier",
            --   group = vim.api.nvim_create_augroup("imiljan-Prettier", { clear = true }),
            --   callback = function()
            --     -- print("Formatting")
            --     vim.lsp.buf.format({ async = false })
            --   end,
            -- })

            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
