return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason-nvim-dap.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "smjonas/inc-rename.nvim", cmd = "IncRename", opts = {} },
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
      local ts = require("imiljan.util.typescript")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("imiljan-LspAttach", { clear = true }),
        callback = function(e)
          local builtin = require("telescope.builtin")

          vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { buffer = e.buf, desc = "LSP: INFO" })

          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = e.buf, desc = "LSP: Definitions" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = e.buf, desc = "LSP: Declaration" })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = e.buf, desc = "LSP: References" })
          vim.keymap.set("n", "gI", builtin.lsp_implementations, { buffer = e.buf, desc = "LSP: Implementations" })
          vim.keymap.set("n", "gy", builtin.lsp_type_definitions, { buffer = e.buf, desc = "LSP: Type Definition" })

          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = e.buf, desc = "LSP: Documentation" })
          vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { buffer = e.buf, desc = "LSP: Signature Help" })
          vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, { buffer = e.buf, desc = "LSP: Signature Help" })

          vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { buffer = e.buf, desc = "LSP: Document Symbols" })
          vim.keymap.set(
            "n",
            "<leader>ws",
            builtin.lsp_dynamic_workspace_symbols,
            { buffer = e.buf, desc = "LSP: Dynamic Workspace Symbols" }
          )
          vim.keymap.set("n", "<leader>wS", function()
            vim.ui.input({ prompt = "Workspace Symbols > " }, function(input)
              builtin.lsp_workspace_symbols({ query = input })
            end)
          end, { buffer = e.buf, desc = "LSP: Workspace Symbols with input" })

          -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = e.buf, desc = "LSP: Rename Symbol" })
          vim.keymap.set("n", "<leader>rn", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
          end, { buffer = e.buf, expr = true, desc = "LSP: Rename Symbol" })

          vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = e.buf, desc = "LSP: Code Action" })
          vim.keymap.set("n", "<leader>cx", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source" },
                diagnostics = {},
              },
            })
          end, { desc = "LSP: Source Action" })

          vim.keymap.set("n", "<leader>wd", builtin.diagnostics, { buffer = e.buf, desc = "Diagnostic: Workspace" })
          vim.keymap.set("n", "<leader>fd", function()
            builtin.diagnostics({ bufnr = 0 })
          end, { buffer = e.buf, desc = "Diagnostic: Document" })

          vim.keymap.set("n", "[d", function()
            vim.diagnostic.goto_prev({ float = false })
          end, { buffer = e.buf, desc = "Diagnostic: prev" })
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.goto_next({ float = false })
          end, { buffer = e.buf, desc = "Diagnostic: next" })

          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = e.buf, desc = "Diagnostic: Messages" })

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
            end -- end tsserver
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
          commands = {
            OrganizeImports = { ts.organize_imports, description = "Organize Imports" },
            RenameFile = { ts.rename_file, description = "Rename File" },
            GoToSourceDefinition = { ts.go_to_source_definition, description = "Go To Source Definition" },
          },
        },

        -- angularls = {
        --   root_dir = require("lspconfig.util").root_pattern("angular.json", "project.json"),
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

        eslint = {
          enabled = true,
          lintTask = {
            enable = true,
          },
          run = "onSave",
          format = { enable = false },
          codeActionsOnSave = {
            mode = "all",
          },
        },

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

      local linter_and_formaters = {
        "stylua",
        "prettierd",
        "prettier",
        "black",
        "isort",
        "shfmt",

        "eslint_d",
        "flake8",
        "actionlint",
        "checkmake",
        "hadolint",
        "yamllint",
        "markdownlint-cli2",
        "tflint",
        "jsonlint",

        "vale",
        "codespell",
      }
      local dap = { "debugpy" } -- js-debug-addapter installed manually, not working here

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, linter_and_formaters)
      vim.list_extend(ensure_installed, dap)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      require("mason").setup()
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup({
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
      -- "nvim-treesitter/nvim-treesitter-context",
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
        highlight = { enable = true },
        indent = { enable = true },
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
              ["af"] = { query = "@function.outer", desc = "Select outer part of the function region" },
              ["if"] = { query = "@function.inner", desc = "Select the inner part of the function region" },
              ["ac"] = { query = "@class.outer", desc = "Select outer part of the class region" },
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = { ["<leader>pn"] = "@parameter.inner" },
            swap_previous = { ["<leader>pp"] = "@parameter.inner" },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
            goto_next = { ["]i"] = "@conditional.outer" },
            goto_previous = { ["[i"] = "@conditional.outer" },
          },
        },
      })

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*.component.html", "*.container.html" },
        callback = function()
          vim.treesitter.start(nil, "angular")
        end,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      {
        "garymjr/nvim-snippets",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = { friendly_snippets = true },
        keys = {
          {
            "<Tab>",
            function()
              return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
            end,
            expr = true,
            silent = true,
            mode = { "i", "s" },
          },
          {
            "<S-Tab>",
            function()
              return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
            end,
            expr = true,
            silent = true,
            mode = { "i", "s" },
          },
        },
      },
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local lspkind = require("lspkind")

      -- vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        preselect = cmp.PreselectMode.None,
        completion = { completeopt = "menu,menuone,noselect,popup" },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
          ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }),
          ["<S-CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "snippets", max_item_count = 3 },
          { name = "path", max_item_count = 3 },
          { name = "lazydev", group_index = 0 },
        }, {
          { name = "buffer", max_item_count = 3 },
        }),
        formatting = {
          expandable_indicator = true,
          fields = { "abbr", "menu", "kind" },
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            show_labelDetails = true,
          }),
        },
        -- experimental = {
        --   ghost_text = {
        --     hl_group = "CmpGhostText",
        --   },
        -- },
        sorting = defaults.sorting,
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer", max_item_count = 15 },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path", max_item_count = 5 },
        }, {
          { name = "cmdline", max_item_count = 15 },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },
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
        python = { "black", "isort" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
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
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        python = { "flake8" },
        -- yaml = { "actionlint" },
        make = { "checkmake" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
        -- markdown = { "markdownlint-cli2" },
        terraform = { "tflint" },
        json = { "jsonlint" },
        text = { "vale" },
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("imiljan-lint", { clear = true }),
        callback = function()
          lint.try_lint()
          lint.try_lint("codespell")
        end,
      })
    end,
  },
}
