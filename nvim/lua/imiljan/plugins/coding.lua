return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        dependencies = { { "Bilal2453/luvit-meta", lazy = true } },
        opts = { library = { { path = "luvit-meta/library", words = { "vim%.uv" } } } },
      },
      {
        "j-hui/fidget.nvim",
        opts = { notification = { window = { winblend = 0 } } },
      },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- "angularls",
          "bashls",
          "cssls",
          "docker_compose_language_service",
          "eslint",
          "html",
          "jsonls",
          "lua_ls",
          "pyright",
          "sqlls",
          "terraformls",
          "ts_ls",
          -- "tsgo",
          "yamlls",
        },
        -- automatic_enable = false,
      })

      -- vim.lsp.enable({
      --   -- "angularls",
      --   "bashls",
      --   "cssls",
      --   "docker_compose_language_service",
      --   "eslint",
      --   "html",
      --   "jsonls",
      --   "lua_ls",
      --   "pyright",
      --   "sqlls",
      --   "terraformls",
      --   "ts_ls",
      --   -- "tsgo",
      --   "yamlls",
      -- })

      local builtin = require("telescope.builtin")
      local tca = require("tiny-code-action")
      local ts = require("imiljan.util.typescript")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("imiljan-LspAttach", { clear = true }),
        callback = function(e)
          --     -- https://github.com/ibhagwan/fzf-lua?tab=readme-ov-file#lspdiagnostics
          --     vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", { buffer = e.buf, desc = "LSP: References" })
          --     vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { buffer = e.buf, desc = "LSP: Definitions" })
          --     vim.keymap.set("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", { buffer = e.buf, desc = "LSP: Declaration" })
          --     vim.keymap.set("n", "gT", "<cmd>FzfLua lsp_typedefs<cr>", { buffer = e.buf, desc = "LSP: Type Definition" })
          --     vim.keymap.set("n", "gI", "<cmd>FzfLua lsp_implementations<cr>", { buffer = e.buf, desc = "LSP: Implementations" })
          --     vim.keymap.set("n", "gO", "<cmd>FzfLua lsp_document_symbols<cr>", { buffer = e.buf, desc = "LSP: Document Symbols" })
          --
          --     vim.keymap.set("n", "<leader>ss", "<cmd>FzfLua lsp_workspace_symbols<cr>", { buffer = e.buf, desc = "LSP: Document Symbols" })
          --     vim.keymap.set("n", "<leader>sS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", { buffer = e.buf, desc = "LSP: Live Workspace Symbols" })
          --
          --     vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", { buffer = e.buf, desc = "Diagnostic: Find in Document" })
          --     vim.keymap.set("n", "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", { buffer = e.buf, desc = "Diagnostic: Find in Workspace" })

          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = e.buf, desc = "LSP: References" })
          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = e.buf, desc = "LSP: Definitions" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = e.buf, desc = "LSP: Declaration" })
          vim.keymap.set("n", "gI", builtin.lsp_implementations, { buffer = e.buf, desc = "LSP: Implementations" })
          vim.keymap.set("n", "gT", builtin.lsp_type_definitions, { buffer = e.buf, desc = "LSP: Type Definition" })
          vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = e.buf, desc = "LSP: Document Symbols" })

          vim.keymap.set("n", "<leader>ss", builtin.lsp_dynamic_workspace_symbols, { buffer = e.buf, desc = "LSP: Dynamic Workspace Symbols" })
          vim.keymap.set("n", "<leader>sS", function()
            vim.ui.input({ prompt = "Workspace Symbols > " }, function(input)
              builtin.lsp_workspace_symbols({ query = input })
            end)
          end, { buffer = e.buf, desc = "LSP: Workspace Symbols with input" })

          vim.keymap.set("n", "<leader>fd", function()
            builtin.diagnostics({ bufnr = 0 })
          end, { buffer = e.buf, desc = "Diagnostic: Find in Document" })
          vim.keymap.set("n", "<leader>fD", builtin.diagnostics, { buffer = e.buf, desc = "Diagnostic: Find in Workspace" })

          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = e.buf, desc = "LSP: Documentation" })
          vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { buffer = e.buf, desc = "LSP: Signature Help" })
          vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, { buffer = e.buf, desc = "LSP: Signature Help" })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = e.buf, desc = "LSP: Rename Symbol" })
          -- vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = e.buf, desc = "LSP: Code Action" })
          vim.keymap.set({ "n", "x" }, "<leader>ca", function()
            tca.code_action({})
          end, { noremap = true, silent = true })

          vim.keymap.set("n", "<leader>cx", function()
            tca.code_action({
              apply = true,
              context = {
                only = { "source" },
                diagnostics = {},
              },
            })
          end, { desc = "LSP: Source Action" })

          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = e.buf, desc = "Diagnostic: Messages" })
          vim.keymap.set("n", "<leader>E", vim.diagnostic.setqflist, { buffer = e.buf, desc = "Diagnostic: QuickFix" })

          vim.diagnostic.config({
            underline = true,
            virtual_lines = false,
            virtual_text = { current_line = true },
            signs = {
              text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.INFO] = "",
                [vim.diagnostic.severity.HINT] = "",
              },
            },
            float = {
              severity_sort = true,
              header = "",
              source = "if_many",
              prefix = "",
              border = "rounded",
            },
            update_in_insert = false,
            severity_sort = false,
            jump = {
              float = false,
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
              -- vim.api.nvim_create_autocmd("BufWritePre", {
              --   group = vim.api.nvim_create_augroup("imiljan-OrganizeImports", {}),
              --   buffer = e.buf,
              --   desc = "TypeScript - On Save",
              --   callback = function(e2)
              --     -- vim.print("Organizing imports for " .. e2.file .. " buffer")
              --     ts.organize_imports(e2.buf)
              --   end,
              -- })

              vim.keymap.set("n", "gs", ts.go_to_source_definition, { buffer = e.buf, desc = "LSP TS: Go To Source Definition" })
              vim.keymap.set("n", "<leader>rf", ts.rename_file, { buffer = e.buf, desc = "LSP TS: Rename File" })
            end -- end ts_ls
          end -- end if client
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
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

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*.component.html", "*.container.html" },
        callback = function()
          vim.treesitter.start(nil, "angular")
        end,
      })
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope.nvim" } },
    event = "LspAttach",
    opts = {
      backend = "delta",
      -- picker = "fzf-lua",
      picker = "telescope",
    },
  },
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "1.*",
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
        --
        -- ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },

        -- overrides
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        -- custom
        ["<CR>"] = { "accept", "fallback" },
      },
      cmdline = {
        keymap = {
          ["<Tab>"] = { "accept" },
          -- ["<CR>"] = { "accept_and_enter", "fallback" },
        },
        completion = {
          menu = {
            auto_show = true,
          },
        },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        menu = {
          border = "single",
          auto_show = true,
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", "source_name" },
            },
            treesitter = { "lsp" },
          },
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
      snippets = {
        preset = "default",
      },
      sources = {
        default = { "lazydev", "snippets", "lsp", "path", "buffer" },
        -- default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          cmdline = {
            min_keyword_length = function(ctx)
              -- when typing a command, only show when the keyword is 3 characters or longer
              if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                return 3
              end
              return 0
            end,
          },
        },
      },
    },
  },
  -- {
  --   "zapling/mason-conform.nvim",
  --   dependencies = {
  --     "mason-org/mason.nvim",
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
      formatters = {
        kulala = {
          command = "kulala-fmt",
          args = { "format", "$FILENAME" },
          stdin = false,
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier", stop_after_first = true },
        typescript = { "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        json = { "jq", "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        -- yaml = { "yamlfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        http = { "kulala" },

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
  --   },
  --   opts = {},
  -- },
  -- {
  -- "rshkarin/mason-nvim-lint",
  -- dependencies = {
  --   "mason-org/mason.nvim",
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        -- lua = { "luacheck" },
        python = { "flake8" },

        -- eslint language server is used instead of this
        -- javascript = { "eslint_d" },
        -- typescript = { "eslint_d" },
        -- javascript = { "eslint" },
        -- typescript = { "eslint" },

        -- yaml = { "actionlint" },
        make = { "checkmake" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
        -- markdown = { "markdownlint-cli2" },
        -- markdown = { "markdownlint" },
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
  --   },
  --   opts = {},
  -- },
}
