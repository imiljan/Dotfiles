return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({ ensure_installed = { "debugpy", "js-debug-adapter" } })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/overseer.nvim",

      -- {
      --   "rcarriga/nvim-dap-ui",
      --   dependencies = { "nvim-neotest/nvim-nio" },
      --   keys = {},
      --   opts = {
      --     controls = {
      --       -- element = "scopes",
      --       enabld = true,
      --       icons = {
      --         play = " 5",
      --         step_out = " 6",
      --         step_into = " 7",
      --         step_over = " 8",
      --         disconnect = "",
      --         pause = "",
      --         run_last = "",
      --         step_back = "",
      --         terminate = "",
      --       },
      --     },
      --     layouts = {
      --       {
      --         elements = {
      --           { id = "scopes", size = 0.25 },
      --           { id = "breakpoints", size = 0.25 },
      --           { id = "stacks", size = 0.25 },
      --           { id = "watches", size = 0.25 },
      --         },
      --         position = "left",
      --         size = 50,
      --       },
      --       {
      --         elements = {
      --           { id = "repl", size = 0.6 },
      --           { id = "console", size = 0.4 },
      --         },
      --         position = "bottom",
      --         size = 10,
      --       },
      --     },
      --   },
      --   config = function(_, opts)
      --     local dap = require("dap")
      --     local dapui = require("dapui")
      --
      --     dapui.setup(opts)
      --
      --     dap.listeners.after.event_initialized["dapui_config"] = function()
      --       dapui.open({})
      --     end
      --     dap.listeners.before.event_terminated["dapui_config"] = function()
      --       dapui.close({})
      --     end
      --     dap.listeners.before.event_exited["dapui_config"] = function()
      --       dapui.close({})
      --     end
      --   end,
      -- },

      {
        "igorlfs/nvim-dap-view",
        keys = {},
        opts = { -- https://igorlfs.github.io/nvim-dap-view/configuration
          winbar = {
            show = true,
            sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
            default_section = "scopes",
            -- Add your own sections
            custom_sections = {},
            controls = {
              enabled = true,
              position = "right",
              buttons = {
                "play",
                "step_out",
                "step_into",
                "step_over",
                "step_back",
                "run_last",
                "terminate",
                "disconnect",
              },
              custom_buttons = {},
            },
          },
          windows = {
            height = 18,
            position = "below",
            terminal = {
              position = "left",
              hide = {},
              start_hidden = false,
            },
          },
          icons = {
            disabled = "",
            disconnect = "",
            enabled = "",
            filter = "󰈲",
            negate = " ",
            pause = "",
            play = "5",
            step_out = "6",
            step_into = "7",
            step_over = "8",
            run_last = "",
            step_back = "",
            terminate = "",
          },
          help = {
            border = nil,
          },
          -- Controls how to jump when selecting a breakpoint or navigating the stack
          switchbuf = "usetab",
          auto_toggle = false,
          -- Reopen dapview when switching tabs
          follow_tab = false,
        },
        config = function(_, opts)
          local dv = require("dap-view")
          local dap = require("dap")

          dv.setup(opts)
          dap.listeners.before.attach["dap-view-config"] = function()
            dv.open()
          end
          dap.listeners.before.launch["dap-view-config"] = function()
            dv.open()
          end
          dap.listeners.before.event_terminated["dap-view-config"] = function()
            dv.close()
          end
          dap.listeners.before.event_exited["dap-view-config"] = function()
            dv.close()
          end
        end,
      },

      {
        "theHamsta/nvim-dap-virtual-text",
        opts = { virt_text_pos = "eol" },
      },

      -- Add your own debug adapters
      {
        "jbyuki/one-small-step-for-vimkind",
        -- stylua: ignore
        keys = {
          { "<leader>dL", function() require("osv").launch({ port = 8086 }) end, desc = "🐛 DAP: Launch Lua adapter" }
        },
      },
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          local path = vim.fn.expand("$MASON/packages/debugpy")
          require("dap-python").setup(path .. "/venv/bin/python", { include_configs = true })

          table.insert(require("dap").configurations.python, 1, {
            name = "Python: Debug Flask",
            type = "debugpy",
            request = "launch",
            module = "flask",
            env = {
              -- FLASK_APP = "app.py",
              FLASK_DEBUG = "1",
            },
            args = { "run", "--no-debugger", "--no-reload" },
            jinja = true,
            autoStartBrowser = false,
          })
          table.insert(require("dap").configurations.python, 2, {
            name = "Python: Debug File",
            type = "debugpy",
            request = "launch",
            program = "${file}",
          })
        end,
      },
    },
  -- stylua: ignore
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "🐛 DAP: Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition > ")) end, desc = "🐛 DAP: Breakpoint Condition" },
    { "<leader>dx", function() require("dap").set_exception_breakpoints() end, desc = "🐛 DAP: Set Exception Breakpoints" },
    { '<leader>dB', '<cmd>Telescope dap list_breakpoints<cr>', desc = '🔭 🐛 DAP: List breakpoints', },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "🐛 DAP: Run to Cursor" },
    { "<F5>", function() require("dap").continue() end, desc = "🐛 DAP: Start/Continue" },
    { "<F6>", function() require("dap").step_out() end, desc = "🐛 DAP: Step Out" },
    { "<F7>", function() require("dap").step_into() end, desc = "🐛 DAP: Step Into" },
    { "<F8>", function() require("dap").step_over() end, desc = "🐛 DAP: Step Over" },

    -- ALL 
    -- { "<leader>dc", function() require("dap").continue() end, desc = "🐛 DAP: Continue" },
    -- { "<leader>d", function() require("dap").run() end, desc = "🐛 DAP: Run" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "🐛 DAP: Run Last" },
    { "<leader>dr", function() require("dap").restart() end, desc = "🐛 DAP: Restart" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "🐛 DAP: Terminate" },
    -- { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition > ")) end, desc = "🐛 DAP: Breakpoint Condition" },
    -- { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "🐛 DAP: Toggle Breakpoint" },
    { "<leader>dq", function() require("dap").list_breakpoints() end, desc = "🐛 DAP: List Breakpoints" },
    { "<leader>dQ", function() require("dap").clear_breakpoints() end, desc = "🐛 DAP: Clear Breakpoints" },
    -- { "<leader>dx", function() require("dap").set_exception_breakpoints() end, desc = "🐛 DAP: Set Exception Breakpoints" },
    -- { "<leader>do", function() require("dap").step_over() end, desc = "🐛 DAP: Step Over" },
    -- { "<leader>di", function() require("dap").step_into() end, desc = "🐛 DAP: Step Into" },
    -- { "<leader>dO", function() require("dap").step_out() end, desc = "🐛 DAP: Step Out" },
    -- { "<leader>dh", function() require("dap").step_back() end, desc = "🐛 DAP: Step Back" },
    -- { "<leader>dp", function() require("dap").pause() end, desc = "🐛 DAP: Pause" },
    -- { "<leader>d", function() require("dap").reverse_continue() end, desc = "🐛 DAP: Reverse Continue" },
    -- { "<leader>dk", function() require("dap").up() end, desc = "🐛 DAP: Up" },
    -- { "<leader>dj", function() require("dap").down() end, desc = "🐛 DAP: Down" },
    -- { "<leader>dg", function() require("dap").goto_() end, desc = "🐛 DAP: Go to Line (No Execute)" },
    -- { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "🐛 DAP: Run to Cursor" },
    -- { "<leader>d", function() require("dap").repl.open() end, desc = "🐛 DAP: REPL Open" },
    { "<leader>dR", function() require("dap").repl.toggle() end, desc = "🐛 DAP: REPL Toggle" },
    -- { "<leader>d", function() require("dap").repl.close() end, desc = "🐛 DAP: REPL Close" },
    -- { "<leader>d", function() require("dap").repl.execute() end, desc = "🐛 DAP: REPL Execute" },
    { "<leader>ds", function() require("dap").session() end, desc = "🐛 DAP: Session" },
    { "<leader>dS", function() require("dap").sessions() end, desc = "🐛 DAP: Sessions" },
    -- { "<leader>d", function() require("dap").status() end, desc = "🐛 DAP: Status" },
    -- { "<leader>d", function() require("dap").disconnect() end, desc = "🐛 DAP: Disconnect" },
    -- { "<leader>d", function() require("dap").close() end, desc = "🐛 DAP: Close" },
    -- { "<leader>d", function() require("dap").launch() end, desc = "🐛 DAP: Launch" },
    -- { "<leader>d", function() require("dap").attach() end, desc = "🐛 DAP: Attach" },

    -- dap-ui
      -- { "<leader>du", function() require("dapui").toggle({}) end, desc = "🐛 DAP UI: Toggle", },
      -- { "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, desc = "🐛 DAP UI: Eval and enter", mode = { "n", "v" }, },
      -- { "<leader>dE", function() vim.ui.input({ prompt = "Eval Expression > " }, function(input) require("dapui").eval(input, { enter = true }) end) end, desc = "🐛 DAP UI: Eval Expression", },

    -- dap-view
    { "<leader>du", function() require("dap-view").toggle() end, desc = "🐛 DAP View: Toggle", },
    { "<leader>dz", "<cmd>DapViewWatch<cr>", desc = "🐛 DAP View: View Watch", mode = { "n", "v" } },

    { "<leader>de", function() require("dap.ui.widgets").hover() end, desc = "🐛 DAP(W): Hover (Eval?)" },
    { "<leader>dE", function() vim.ui.input({ prompt = "Eval Expression > " }, function(input) require("dap.ui.widgets").hover(input) end) end, desc = "🐛 DAP(W): Hover (Eval Explression?)" },

    { "<leader>dw", function() require("dap.ui.widgets").preview() end, desc = "🐛 DAP(W): Preview (Eval?)" },
    { "<leader>dW", function() vim.ui.input({ prompt = "Eval Expression > " }, function(input) require("dap.ui.widgets").preview(input) end) end, desc = "🐛 DAP(W): Preview (Eval Expression?)" },

  },
    config = function()
      local dap = require("dap")

      pcall(require("telescope").load_extension, "dap")

      dap.defaults.fallback.exception_breakpoints = "default"

      -- Icons
      vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
      vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
      local icons = {
        Stopped = "",
        Breakpoint = "",
        BreakpointCondition = "",
        BreakpointRejected = "",
        LogPoint = "",
      }
      for name, icon in pairs(icons) do
        local hl = (name == "Stopped") and "DapStop" or "DapBreak"
        vim.fn.sign_define("Dap" .. name, { text = icon, texthl = hl, numhl = hl })
      end

      -- Use overseer for running preLaunchTask and postDebugTask.
      require("overseer").enable_dap()
      require("dap.ext.vscode").json_decode = require("overseer.json").decode

      -- TypeScript/JavaScript debug adapters - nvim-dap-vscode-js is unmainained 💀
      local js_debug_path = vim.fn.expand("$MASON/packages/js-debug-adapter")
      local DAP_TYPES = { "node", "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }
      for _, adapter in ipairs(DAP_TYPES) do
        dap.adapters[adapter] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
          },
        }
      end

      -- TypeScript/JavaScript configurations
      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            name = "Node: Attach",
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            name = "Node: Launch file",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            protocol = "inspector",
            console = "integratedTerminal",
          },
          {
            name = "Node: Debug Mocha Tests",
            type = "pwa-node",
            request = "launch",
            program = "${file}",

            env = {
              ENV = "staging",
            },

            trace = true, -- include debugger info
            runtimeExecutable = "node",

            runtimeArgs = { "${workspaceFolder}/node_modules/mocha/bin/_mocha" },
            args = { "-r", "ts-node/register", "--timeout", "999999", "--colors" },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "internalConsole",

            -- console = "integratedTerminal",
            -- internalConsoleOptions = "neverOpen",
          },
        }
      end

      -- Lua configurations.
      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }
    end,
  },
}
