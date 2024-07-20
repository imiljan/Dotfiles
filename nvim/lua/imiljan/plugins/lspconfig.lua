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

          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = e.buf, desc = "LSP: Definitions" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = e.buf, desc = "LSP: Declaration" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = e.buf, desc = "LSP: Documentation" })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = e.buf, desc = "LSP: References" })
          vim.keymap.set("n", "gI", builtin.lsp_implementations, { buffer = e.buf, desc = "LSP: Implementations" })
          vim.keymap.set("n", "gT", builtin.lsp_type_definitions, { buffer = e.buf, desc = "LSP: Type Definition" })

          vim.keymap.set(
            "n",
            "<leader>ds",
            builtin.lsp_document_symbols,
            { buffer = e.buf, desc = "LSP: Document Symbols" }
          )
          vim.keymap.set(
            "n",
            "<leader>ws",
            builtin.lsp_dynamic_workspace_symbols,
            { buffer = e.buf, desc = "LSP: Dynamic Workspace Symbols" }
          )
          vim.keymap.set("n", "<leader>wS", function()
            builtin.lsp_workspace_symbols({ query = vim.fn.input("Workspace Symbols > ") })
          end, { buffer = e.buf, desc = "LSP: Workspace Symbols with input" })

          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = e.buf, desc = "LSP: Rename" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = e.buf, desc = "LSP: Code Action" })
          vim.keymap.set("n", "<leader>ff", function()
            vim.lsp.buf.format({
              filter = function(c)
                return c.name == "null-ls"
              end,
            })
          end, { buffer = e.buf, desc = "LSP: Format File" })
          vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, { buffer = e.buf, desc = "LSP: Signature Help" })

          vim.keymap.set("n", "<leader>wd", builtin.diagnostics, { buffer = e.buf, desc = "Diagnostic: Workspace" })
          vim.keymap.set("n", "<leader>fd", function()
            builtin.diagnostics({ bufnr = 0 })
          end, { buffer = e.buf, desc = "Diagnostic: Document" })
          vim.keymap.set("n", "[d", function()
            vim.diagnostic.goto_prev({ float = false })
          end, { buffer = e.buf, desc = "Diagnostic: Go to previous" })
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.goto_next({ float = false })
          end, { buffer = e.buf, desc = "Diagnostic: Go to next" })
          vim.keymap.set(
            "n",
            "<leader>e",
            vim.diagnostic.open_float,
            { buffer = e.buf, desc = "Diagnostic: Show messages" }
          )
          vim.keymap.set(
            "n",
            "<leader>qq",
            vim.diagnostic.setqflist,
            { buffer = e.buf, desc = "Diagnostic: Open QuickFix list" }
          )
          vim.keymap.set(
            "n",
            "<leader>ll",
            vim.diagnostic.setloclist,
            { buffer = e.buf, desc = "Diagnostic: Open Location list" }
          )

          -- For list of capabilities
          -- :lua =vim.lsp.get_active_clients()[1].server_capabilities
          local client = vim.lsp.get_client_by_id(e.data.client_id)

          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.keymap.set("n", "<leader>lh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end, { buffer = e.buf, desc = "LSP: Toggle Inlay Hints" })
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

          -- LSP specific overrides

          if client and client.name == "lua_ls" then
            client.server_capabilities.documentFormattingProvider = false
          end

          if client and client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false

            vim.api.nvim_create_autocmd("BufWritePre", {
              pattern = { "*.ts" },
              desc = "TypeScript - On Save",
              group = vim.api.nvim_create_augroup("imiljan-OrganizeImports", { clear = true }),
              callback = function()
                -- print("Organize Imports " .. vim.api.nvim_buf_get_name(0))
                vim.lsp.buf.execute_command({
                  command = "_typescript.organizeImports",
                  arguments = { vim.api.nvim_buf_get_name(0) },
                  title = "TypeScript Organize Imports",
                })
              end,
            })

            -- https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#workspace-commands-workspaceexecutecommand

            -- vim.keymap.set("n", "g...", function ()
            --   local params = vim.lsp.util.make_position_params()
            --   vim.lsp.buf.execute_command({
            --     command = "_typescript.goToSourceDefinition",
            --     arguments = { params.textDocument.uri, params.position },
            --     open = true,
            --     title = "TypeScript Organize Imports",
            --   })
            -- end,{ buffer = e.buf, desc = "LSP TS: Goto Source Definition" })

            -- This exists in vtsls
            -- vim.keymap.set("n", "gR", function ()
            --   vim.lsp.buf.execute_command({
            --     command = "_typescript.findAllFileReferences",
            --     arguments = { vim.uri_from_bufnr(0) },
            --     open = true,
            --     title = "TypeScript Find All File References",
            --   })
            -- end, { buffer = e.buf, desc = "LSP TS: File References" })

            vim.keymap.set("n", "<leader>co", function()
              vim.lsp.buf.execute_command({
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
                title = "TypeScript Organize Imports",
              })
            end, { buffer = e.buf, desc = "LSP TS: Organize Imports" })

            -- https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#features

            vim.keymap.set("n", "<leader>cD", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.fixAll.ts" },
                  diagnostics = {},
                },
              })
            end, { desc = "LSP TS: Fix all diagnostics" })

            vim.keymap.set("n", "<leader>cu", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnused.ts" },
                  diagnostics = {},
                },
              })
            end, { desc = "LSP TS: Remove Unused Imports" })

            vim.keymap.set("n", "<leader>cm", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.addMissingImports.ts" },
                  diagnostics = {},
                },
              })
            end, { desc = "LSP TS: Add Missing Imports" })

            vim.keymap.set("n", "<leader>cx", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnusedImports.ts" },
                  diagnostics = {},
                },
              })
            end, { desc = "LSP TS: Remove Unused Imports" })

            vim.keymap.set("n", "<leader>cS", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.sortImports.ts" },
                  diagnostics = {},
                },
              })
            end, { desc = "LSP TS: Sort Imports" })

            -- vim.keymap.set("n", "<leader>co", function ()
            --   vim.lsp.buf.code_action({
            --     apply = true,
            --     context = {
            --       only = { "source.organizeImports.ts" },
            --       diagnostics = {},
            --     },
            --   })
            -- end, { desc = "LSP TS: Organize Imports" })
          end

          if client and client.name == "pyright" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end,
      })

      -- :help lspconfig-setup
      local servers = {
        -- Full example of all settings from lspconfig-setup. In any case, always check LSP docs
        lua_ls = {
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
              -- format = {},
              hint = {
                arrayIndex = "Disable",
                enable = true,
                paramName = "Disable",
                paramType = true,
                semicolon = "Disable",
                setType = false,
              },
              -- hover = {},
              -- misc = {},
              -- runtime = {},
              -- semantic = {},
              -- spell = {},
              -- telemetry = {},
              -- type = {},
              -- window = {},
              workspace = { checkThirdParty = false },
            },
          },
        },

        tsserver = { -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#configuration
          init_options = { -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#initializationoptions
            -- hostInfo = "",
            -- completionDisableFilterText = false,
            -- disableAutomaticTypingAcquisition = false,
            -- maxTsServerMemory = 4096,
            -- npmLocation = "",
            -- locale = "",
            -- plugins = {}, -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#plugins-option
            -- tsserver = {}, -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#tsserver-options
            preferences = { -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#preferences-options
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
              -- interactiveInlayHints = true,
              -- jsxAttributeCompletionStyle = "auto",
              -- displayPartsForJSDoc = true,
              -- excludeLibrarySymbolsInNavTo = true,
              -- generateReturnInDocTemplate = true,
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          settings = {
            -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#workspacedidchangeconfiguration
            typescript = {
              -- Formatting preferences
              format = {
                baseIndentSize = 2,
                convertTabsToSpaces = true,
                indentSize = 2,
                indentStyle = "None",
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
                -- newLineCharacter = '',
                placeOpenBraceOnNewLineForControlBlocks = false,
                placeOpenBraceOnNewLineForFunctions = false,
                semicolons = "ignore",
                tabSize = 2,
                trimTrailingWhitespace = true,
              },
              -- -- Inlay Hints preferences
              -- inlayHints = {
              --   includeInlayEnumMemberValueHints = true,
              --   includeInlayFunctionLikeReturnTypeHints = true,
              --   includeInlayFunctionParameterTypeHints = true,
              --   includeInlayParameterNameHints = "none", -- 'none' | 'literals' | 'all';
              --   includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              --   includeInlayPropertyDeclarationTypeHints = true,
              --   includeInlayVariableTypeHints = true,
              --   includeInlayVariableTypeHintsWhenTypeMatchesName = true,
              -- },
              -- -- Code Lens preferences
              -- implementationsCodeLens = {
              --   enabled = true,
              -- },
              -- referencesCodeLens = {
              --   enabled = true,
              --   showOnAllFunctions = true,
              -- },
            },
            javascript = {
              -- Formatting preferences
              format = {
                baseIndentSize = 2,
                convertTabsToSpaces = true,
                indentSize = 2,
                indentStyle = "None",
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
                -- newLineCharacter = '',
                placeOpenBraceOnNewLineForControlBlocks = false,
                placeOpenBraceOnNewLineForFunctions = false,
                semicolons = "ignore",
                tabSize = 2,
                trimTrailingWhitespace = true,
              },
              -- -- Inlay Hints preferences
              -- inlayHints = {
              --   includeInlayEnumMemberValueHints = true,
              --   includeInlayFunctionLikeReturnTypeHints = true,
              --   includeInlayFunctionParameterTypeHints = true,
              --   includeInlayParameterNameHints = "none", -- 'none' | 'literals' | 'all';
              --   includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              --   includeInlayPropertyDeclarationTypeHints = true,
              --   includeInlayVariableTypeHints = true,
              --   includeInlayVariableTypeHintsWhenTypeMatchesName = true,
              -- },
              -- -- Code Lens preferences
              -- implementationsCodeLens = {
              --   enabled = true,
              -- },
              -- referencesCodeLens = {
              --   enabled = true,
              --   showOnAllFunctions = true,
              -- },
            },
            -- completions = {
            --   completeFunctionCalls = false,
            -- },
            -- diagnostics = {
            --   ignoredCodes = {},
            -- },
            -- implicitProjectConfiguration = {
            --   checkJs = true,
            --   experimentalDecorators = "ESNext",
            --   module = true,
            --   strictFunctionTypes = true,
            --   strictNullChecks = true,
            --   target = "ES2020",
            -- },
          },
          -- from https://neovim.io/doc/user/lsp.html#vim.lsp.ClientConfig
          -- {commands} (table<string,fun(command: lsp.Command, ctx: table)>)
          -- Table that maps string of clientside commands to user-defined functions.
          -- Commands passed to start_client take precedence over the global command registry.
          -- Each key must be a unique command name, and the value is a function which is called
          -- if any LSP action (code action, code lenses, ...) triggers the command.
          commands = {
            -- https://github.com/typescript-language-server/typescript-language-server/tree/master?tab=readme-ov-file#workspace-commands-workspaceexecutecommand
            -- https://github.com/typescript-language-server/typescript-language-server/blob/master/README.md#organize-imports
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

        -- angularls = {
        --   root_dir = require("lspconfig.util").root_pattern("angular.json", "project.json"),
        -- },

        pyright = { -- Just for example
          -- settings = {
          --   pyright = { -- https://microsoft.github.io/pyright/#/settings?id=pyright-settings
          --     disableLanguageServices = false,
          --     disableOrganizeImports = false,
          --     disableTaggedHints = false,
          --     -- ...
          --   },
          -- },
        },

        bashls = {},
        terraformls = {},
        dockerls = {},
        docker_compose_language_service = {},
        marksman = {},
      }

      local ensure_installed = vim.tbl_keys(servers or {})

      local linters =
        { "eslint_d", "flake8", "codespell", "actionlint", "checkmake", "hadolint", "yamllint", "markdownlint_cli2" }
      local formatters = { "stylua", "prettierd", "black", "isort", "jq" }
      local debuggers = { "debugpy" } -- js-debug-addapter installed manually, not working here

      vim.list_extend(ensure_installed, linters)
      vim.list_extend(ensure_installed, formatters)
      vim.list_extend(ensure_installed, debuggers)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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

            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
