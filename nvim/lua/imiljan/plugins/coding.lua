return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
      "nvim-telescope/telescope.nvim",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        dependencies = {
          { "Bilal2453/luvit-meta", lazy = true },
        },
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
      require("mason").setup()

      local ts = require("imiljan.util.typescript")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("imiljan-LspAttach", { clear = true }),
        callback = function(e)
          local builtin = require("telescope.builtin")

          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = e.buf, desc = "LSP: Definitions" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = e.buf, desc = "LSP: Declaration" })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = e.buf, desc = "LSP: References" })
          vim.keymap.set("n", "gI", builtin.lsp_implementations, { buffer = e.buf, desc = "LSP: Implementations" })
          vim.keymap.set("n", "gT", builtin.lsp_type_definitions, { buffer = e.buf, desc = "LSP: Type Definition" })
          vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = e.buf, desc = "LSP: Document Symbols" })

          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = e.buf, desc = "LSP: Documentation" })
          vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { buffer = e.buf, desc = "LSP: Signature Help" })
          vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, { buffer = e.buf, desc = "LSP: Signature Help" })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = e.buf, desc = "LSP: Rename Symbol" })
          vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = e.buf, desc = "LSP: Code Action" })

          vim.keymap.set("n", "<leader>ss", builtin.lsp_dynamic_workspace_symbols, { buffer = e.buf, desc = "LSP: Dynamic Workspace Symbols" })
          vim.keymap.set("n", "<leader>sS", function()
            vim.ui.input({ prompt = "Workspace Symbols > " }, function(input)
              builtin.lsp_workspace_symbols({ query = input })
            end)
          end, { buffer = e.buf, desc = "LSP: Workspace Symbols with input" })

          vim.keymap.set("n", "<leader>cx", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source" },
                diagnostics = {},
              },
            })
          end, { desc = "LSP: Source Action" })

          vim.keymap.set("n", "[d", function()
            vim.diagnostic.goto_prev({ float = false })
          end, { buffer = e.buf, desc = "Diagnostic: prev" })
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.goto_next({ float = false })
          end, { buffer = e.buf, desc = "Diagnostic: next" })
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = e.buf, desc = "Diagnostic: Messages" })
          vim.keymap.set("n", "<leader>E", vim.diagnostic.setqflist, { buffer = e.buf, desc = "Diagnostic: QuickFix" })

          vim.keymap.set("n", "<leader>fd", function()
            builtin.diagnostics({ bufnr = 0 })
          end, { buffer = e.buf, desc = "Diagnostic: Document" })
          vim.keymap.set("n", "<leader>fD", builtin.diagnostics, { buffer = e.buf, desc = "Diagnostic: Workspace" })

          vim.diagnostic.config({
            signs = {
              text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.INFO] = "",
                [vim.diagnostic.severity.HINT] = "",
              },
            },
          })

          -- For list of capabilities
          -- :lua vim.print(vim.lsp.get_active_clients()[1].server_capabilities)
          local client = vim.lsp.get_client_by_id(e.data.client_id)
          if client then
            if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
              vim.keymap.set("n", "<leader>lh", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
              end, { buffer = e.buf, desc = "LSP: Toggle Inlay Hints" })
            end -- end inlay_hint

            if client.server_capabilities.documentHighlightProvider then
              local highlight_augroup = vim.api.nvim_create_augroup("imiljan-LspHighlight", { clear = false })
              vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = highlight_augroup,
                buffer = e.buf,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                group = highlight_augroup,
                buffer = e.buf,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("imiljan-LspDetach", { clear = true }),
                callback = function(e2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds({ group = "imiljan-LspHighlight", buffer = e2.buf })
                end,
              })
            end -- end documentHighlightProvider

            -- LSP specific overrides
            if client.name == "ts_ls" then
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("imiljan-OrganizeImports", {}),
                buffer = e.buf,
                desc = "TypeScript - On Save",
                callback = function(e2)
                  ts.organize_imports(e2.buf)
                end,
              })

              vim.keymap.set("n", "gs", ts.go_to_source_definition, { buffer = e.buf, desc = "LSP TS: Go To Source Definition" })
              vim.keymap.set("n", "<leader>rf", ts.rename_file, { buffer = e.buf, desc = "LSP TS: Rename File" })
            end -- end ts_ls
          end -- end if client
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

        ts_ls = {
          -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#configuration
          init_options = { -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#initializationoptions
            -- hostInfo = "",
            -- completionDisableFilterText = false,
            -- disableAutomaticTypingAcquisition = false,
            maxTsServerMemory = 4096, -- default undefined
            -- npmLocation = "",
            -- locale = "",
            -- plugins = {}, -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#plugins-option
            -- tsserver = {}, -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#tsserver-options
            preferences = { -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#preferences-options
              -- DEFAULT PREFERENCES https://github.com/typescript-language-server/typescript-language-server/blob/b224b878652438bcdd639137a6b1d1a6630129e4/src/features/fileConfigurationManager.ts#L25

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
            completions = {
              completeFunctionCalls = true,
            },
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
          commands = {
            OrganizeImports = { ts.organize_imports, description = "Organize Imports" },
            RenameFile = { ts.rename_file, description = "Rename File" },
            GoToSourceDefinition = { ts.go_to_source_definition, description = "Go To Source Definition" },
          },
        },

        -- angularls = {
        --   root_dir = require("lspconfig.util").root_pattern("nx.json", "angular.json", "project.json"),
        -- },

        pyright = {
          -- settings = {
          --   pyright = { -- https://microsoft.github.io/pyright/#/settings?id=pyright-settings
          --     disableLanguageServices = false,
          --     disableOrganizeImports = false,
          --     disableTaggedHints = false,
          --     -- ...
          --   },
          -- },
        },

        -- 1.4GB ????
        -- eslint = {
        --   codeAction = {
        --     disableRuleComment = {
        --       enable = true,
        --       location = "separateLine",
        --     },
        --     showDocumentation = {
        --       enable = true,
        --     },
        --   },
        --   codeActionOnSave = {
        --     enable = false,
        --     mode = "all",
        --   },
        --   experimental = {
        --     useFlatConfig = false,
        --   },
        --   format = false,
        --   nodePath = "",
        --   onIgnoredFiles = "off",
        --   problems = {
        --     shortenToSingleLine = false,
        --   },
        --   quiet = false,
        --   rulesCustomizations = {},
        --   run = "onSave",
        --   useESLintClass = false,
        --   validate = "on",
        --   workingDirectory = {
        --     mode = "location",
        --   },
        -- },

        html = { filetypes = { "html" } },
        cssls = {},
        sqlls = {},
        jsonls = {},
        yamlls = {},
        bashls = {},
        terraformls = {},
        dockerls = {},
        docker_compose_language_service = {},
        -- marksman = {},
      }

      if vim.g.enable_ng == 1 then
        local angularls_path = require("mason-registry").get_package("angular-language-server"):get_install_path()
        vim.print(angularls_path)

        servers["ts_ls"]["root_dir"] = require("lspconfig.util").root_pattern("nx.json", "tsconfig.json")
        servers["ts_ls"]["init_options"]["plugins"] = {
          {
            name = "@angular/language-server",
            location = angularls_path .. "/node_modules/@angular/language-server",
          },
        }
        servers["angularls"] = {
          root_dir = require("lspconfig.util").root_pattern("nx.json", "angular.json", "project.json"),
        }
      end

      local linter_and_formaters = {
        "stylua",
        -- "prettier",
        "prettierd",
        -- "black",
        -- "isort",
        "yamlfmt",
        "shfmt",

        -- "eslint_d",
        -- "flake8",
        "actionlint",
        "checkmake",
        "hadolint",
        "yamllint",
        -- "markdownlint-cli2",
        "tflint",
        "jsonlint",

        "vale",
        "codespell",
      }
      local dap = { "debugpy", "js-debug-adapter" }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, linter_and_formaters)
      vim.list_extend(ensure_installed, dap)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {},
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}

            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            server.inlay_hints = { enabled = true }
            server.codelens = { enabled = false }

            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- "nvim-treesitter/nvim-treesitter-context"
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        modules = {},
        ensure_installed = {
          "angular",
          "bash",
          "diff",
          "gitcommit",
          "git_rebase",
          "html",
          "javascript",
          "json",
          "jsonc",
          "lua",
          "scss",
          "python",
          "tmux",
          "toml",
          "typescript",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
        },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        -- :h nvim-treesitter-modules
        indent = { enable = true },
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = false,
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["ao"] = { query = "@block.outer", desc = "Select outer part of the block region" },
              ["io"] = { query = "@block.inner", desc = "Select inner part of the block region" },
              ["af"] = { query = "@function.outer", desc = "Select outer part of the function region" },
              ["if"] = { query = "@function.inner", desc = "Select inner part of the function region" },
              ["ac"] = { query = "@class.outer", desc = "Select outer part of the class region" },
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = { ["<leader>an"] = "@parameter.inner" },
            swap_previous = { ["<leader>ap"] = "@parameter.inner" },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]o"] = "@block.outer",
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]O"] = "@block.outer",
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[o"] = "@block.outer",
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[O"] = "@block.outer",
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[A"] = "@parameter.inner",
            },
            goto_next = {
              ["]i"] = "@conditional.outer",
            },
            goto_previous = {
              ["[i"] = "@conditional.outer",
            },
          },
          lsp_interop = {
            enable = true,
            border = "rounded",
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>df"] = "@function.outer",
              ["<leader>dF"] = "@class.outer",
            },
          },
        },
      })

      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

      -- Repeat movement with ; and ,
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

      -- require("treesitter-context").setup({ enable = true, max_lines = 3, min_window_height = 3 })

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*.component.html", "*.container.html" },
        callback = function()
          vim.treesitter.start(nil, "angular")
        end,
      })
    end,
  },
  {
    "github/copilot.vim",
  },
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",
    opts = {
      keymap = {
        preset = "default",

        -- default options
        -- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        -- ["<C-e>"] = { "hide" },
        -- ["<C-y>"] = { "select_and_accept" },
        --
        -- ["<C-p>"] = { "select_prev", "fallback" },
        -- ["<C-n>"] = { "select_next", "fallback" },
        --
        -- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        -- ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        --
        -- ["<Tab>"] = { "snippet_forward", "fallback" },
        -- ["<S-Tab>"] = { "snippet_backward", "fallback" },

        -- overrides
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        -- custom
        ["<CR>"] = { "accept", "fallback" },

        -- cmdline = { preset = "super-tab" },
      },
      -- https://cmp.saghen.dev/configuration/reference.html#reference
      --
      -- https://cmp.saghen.dev/configuration/reference.html#completion-keyword
      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          border = "single",
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
          draw = { treesitter = { "lsp" } },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          update_delay_ms = 50,
          window = {
            border = "single",
          },
        },
        ghost_text = {
          enabled = false,
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "single",
        },
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
    },
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = { "InsertEnter", "CmdlineEnter" },
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-buffer",
  --     "hrsh7th/cmp-path",
  --     "hrsh7th/cmp-cmdline",
  --     "onsails/lspkind.nvim",
  --     {
  --       "garymjr/nvim-snippets",
  --       dependencies = { "rafamadriz/friendly-snippets" },
  --       opts = { friendly_snippets = true },
  --       keys = {
  --         {
  --           "<Tab>",
  --           function()
  --             return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
  --           end,
  --           expr = true,
  --           silent = true,
  --           mode = { "i", "s" },
  --         },
  --         {
  --           "<S-Tab>",
  --           function()
  --             return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
  --           end,
  --           expr = true,
  --           silent = true,
  --           mode = { "i", "s" },
  --         },
  --       },
  --     },
  --   },
  --   config = function()
  --     local cmp = require("cmp")
  --     local defaults = require("cmp.config.default")()
  --     local lspkind = require("lspkind")
  --
  --     cmp.setup({
  --       snippet = {
  --         expand = function(args)
  --           vim.snippet.expand(args.body)
  --         end,
  --       },
  --       preselect = cmp.PreselectMode.None,
  --       completion = { completeopt = "menu,menuone,noselect,popup" },
  --       window = {
  --         completion = cmp.config.window.bordered(),
  --         documentation = cmp.config.window.bordered(),
  --       },
  --       mapping = cmp.mapping.preset.insert({
  --         ["<C-u>"] = cmp.mapping.scroll_docs(-4),
  --         ["<C-d>"] = cmp.mapping.scroll_docs(4),
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         ["<C-e>"] = cmp.mapping.abort(),
  --         ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
  --         ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }),
  --         ["<S-CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
  --       }),
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp" },
  --         { name = "snippets" },
  --         { name = "path" },
  --         { name = "lazydev", group_index = 0 },
  --       }, {
  --         { name = "buffer" },
  --       }),
  --       formatting = {
  --         expandable_indicator = true,
  --         fields = { "abbr", "menu", "kind" },
  --         format = lspkind.cmp_format({
  --           mode = "symbol_text",
  --           maxwidth = 50,
  --           ellipsis_char = "...",
  --           show_labelDetails = true,
  --         }),
  --       },
  --       sorting = defaults.sorting,
  --     })
  --
  --     cmp.setup.cmdline({ "/", "?" }, {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = {
  --         { name = "buffer", max_item_count = 30 },
  --       },
  --     })
  --
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = cmp.config.sources({
  --         { name = "path", max_item_count = 30 },
  --       }, {
  --         { name = "cmdline", max_item_count = 30 },
  --       }),
  --       matching = { disallow_symbol_nonprefix_matching = false },
  --     })
  --   end,
  -- },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>ff",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "Format File",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        json = { "jq", "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "yamlfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },

        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
      },
      notify_on_error = false,
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        -- lua = { "luacheck" },
        python = { "flake8" },
        -- javascript = { "eslint_d" },
        -- typescript = { "eslint_d" },

        javascript = { "eslint" },
        typescript = { "eslint" },

        -- yaml = { "actionlint" },
        make = { "checkmake" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
        -- markdown = { "markdownlint-cli2" },
        terraform = { "tflint" },
        json = { "jsonlint" },
        text = { "vale" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        -- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("imiljan-lint", { clear = true }),
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
            lint.try_lint("codespell")
          end
        end,
      })
    end,
  },
}
