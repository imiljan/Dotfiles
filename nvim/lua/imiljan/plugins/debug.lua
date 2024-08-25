return {
  "mfussenegger/nvim-dap",
  ft = { "typescript", "javascript", "python" },
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      keys = {
        {
          "<leader>du",
          function()
            require("dapui").toggle({})
          end,
          desc = "DAP: UI",
        },
        {
          "<leader>de",
          function()
            require("dapui").eval(nil, { enter = true })
          end,
          desc = "DAP: Eval and enter",
          mode = { "n", "v" },
        },
        {
          "<leader>dE",
          function()
            vim.ui.input({ prompt = "Eval Expression > " }, function(input)
              require("dapui").eval(input, { enter = true })
            end)
          end,
          desc = "DAP: Eval Expression",
        },
      },
      opts = {
        controls = {
          element = "scopes",
          enabld = true,
          icons = {
            play = " (5)",
            step_into = " (7)",
            step_over = " (8)",
            step_out = " (9)",
            disconnect = "",
            pause = "",
            run_last = "",
            step_back = "",
            terminate = "",
          },
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 50,
          },
          {
            elements = {
              { id = "repl", size = 0.6 },
              { id = "console", size = 0.4 },
            },
            position = "bottom",
            size = 10,
          },
        },
      },
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup(opts)

        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end,
    },
    { "theHamsta/nvim-dap-virtual-text", opts = {} },

    -- Add your own debuggers here
    {
      "jbyuki/one-small-step-for-vimkind",
      keys = {
        {
          "<leader>dL",
          function()
            require("osv").launch({ port = 8086 })
          end,
          desc = "DAP: Launch Lua adapter",
        },
      },
    },
    {
      "mxsdev/nvim-dap-vscode-js",
      ft = { "typescript", "javascript" },
      dependencies = {
        {
          "microsoft/vscode-js-debug",
          -- build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
          build = "npm ci && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out",
          ft = { "typescript", "javascript" },
        },
      },
      opts = {
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      },
    },
    {
      "mfussenegger/nvim-dap-python",
      ft = "python",
      config = function()
        local path = require("mason-registry").get_package("debugpy"):get_install_path()
        return require("dap-python").setup(path .. "/venv/bin/python")
      end,
    },
  },
  keys = {
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "DAP: Continue",
    },
    {
      "<leader>da",
      function()
        require("dap").continue({ before = get_args })
      end,
      desc = "DAP: Run with Args",
    },
    -- { "<leader>d", function() require("dap").run() end,                                                desc = "DAP: Run" },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "DAP: Run Last",
    },
    {
      "<leader>dr",
      function()
        require("dap").restart()
      end,
      desc = "DAP: Toggle REPL",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "DAP: Terminate",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition > "))
      end,
      desc = "DAP: Breakpoint Condition",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "DAP: Toggle Breakpoint",
    },
    {
      "<leader>dq",
      function()
        require("dap").list_breakpoints()
      end,
      desc = "DAP: List Breakpoints",
    },
    {
      "<leader>dQ",
      function()
        require("dap").clear_breakpoints()
      end,
      desc = "DAP: Clear Breakpoints",
    },
    {
      "<leader>dx",
      function()
        require("dap").set_exception_breakpoints()
      end,
      desc = "DAP: Set Exception Breakpoints",
    },
    {
      "<leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "DAP: Step Over",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "DAP: Step Into",
    },
    {
      "<leader>dO",
      function()
        require("dap").step_out()
      end,
      desc = "DAP: Step Out",
    },
    {
      "<leader>dh",
      function()
        require("dap").step_back()
      end,
      desc = "DAP: Step Back",
    },
    {
      "<leader>dp",
      function()
        require("dap").pause()
      end,
      desc = "DAP: Pause",
    },
    -- { "<leader>d", function() require("dap").reverse_continue() end,                                   desc = "DAP: Pause" },
    {
      "<leader>dk",
      function()
        require("dap").up()
      end,
      desc = "DAP: Up",
    },
    {
      "<leader>dj",
      function()
        require("dap").down()
      end,
      desc = "DAP: Down",
    },
    {
      "<leader>dg",
      function()
        require("dap").goto_()
      end,
      desc = "DAP: Go to Line (No Execute)",
    },
    {
      "<leader>dC",
      function()
        require("dap").run_to_cursor()
      end,
      desc = "DAP: Run to Cursor",
    },
    -- { "<leader>d", function() require("dap").repl.open() end,                                          desc = "DAP: REPL" },
    -- { "<leader>d", function() require("dap").repl.toggle() end,                                        desc = "DAP: REPL" },
    -- { "<leader>d", function() require("dap").repl.close() end,                                         desc = "DAP: REPL" },
    -- { "<leader>d", function() require("dap").repl.execute() end,                                       desc = "DAP: REPL" },
    {
      "<leader>ds",
      function()
        require("dap").session()
      end,
      desc = "DAP: Session",
    },
    {
      "<leader>dS",
      function()
        require("dap").sessions()
      end,
      desc = "DAP: Sessions",
    },
    -- { "<leader>d", function() require("dap").status() end,                                             desc = "DAP: Status" },
    -- { "<leader>d", function() require("dap").disconnect() end,                                         desc = "DAP: Disconnect" },
    -- { "<leader>d", function() require("dap").close() end,                                              desc = "DAP: Close" },
    -- { "<leader>d", function() require("dap").launch() end,                                             desc = "DAP: Launch" },
    -- { "<leader>d", function() require("dap").attach() end,                                             desc = "DAP: Attach" },

    -- { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "DAP(Widgets): Eval Hover" },
    -- { "<leader>dW", function() require("dap.ui.widgets").preview() end,                                   desc = "DAP(Widgets): Eval Preview" },

    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<F7>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<F8>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<F9>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
  },
  config = function()
    local dap = require("dap")
    local dap_util = require("dap.utils")

    dap.defaults.fallback.exception_breakpoints = "default"

    -- Set up icons.
    local icons = {
      Stopped = { "", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint = "",
      BreakpointCondition = "",
      BreakpointRejected = { "", "DiagnosticError" },
      LogPoint = "",
    }
    for name, sign in pairs(icons) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define("Dap" .. name, { text = sign[1] .. " ", texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] })
    end

    -- vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "", linehl = "", numhl = "" })
    -- vim.fn.sign_define("DapBreakpointCondition", { text = "?●", texthl = "", linehl = "", numhl = "" })
    -- vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "", linehl = "", numhl = "" })
    -- vim.fn.sign_define("DapStopped", { text = "■", texthl = "", linehl = "", numhl = "" })
    -- vim.fn.sign_define("DapBreakpointRejected", { text = "!●", texthl = "", linehl = "", numhl = "" })

    -- Lua configurations.
    dap.adapters.nlua = function(callback, config)
      callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end
    dap.configurations["lua"] = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
      },
    }

    for _, language in ipairs({ "typescript", "javascript" }) do
      dap.configurations[language] = {
        {
          name = "Node: Launch file",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          name = "Node: Attach",
          type = "pwa-node",
          request = "attach",
          processId = dap_util.pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          name = "Node: Debug Mocha Tests",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          runtimeArgs = { "${workspaceFolder}/node_modules/mocha/bin/_mocha" },
          args = {
            "-r",
            "ts-node/register",
            "--timeout",
            "999999",
            "--colors",
          },
          rootPath = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
      }
    end

    dap.configurations.python = {
      {
        name = "Python: Debug Flask",
        type = "debugpy",
        request = "launch",
        module = "flask",
        env = {
          -- FLASK_APP = "app.py",
          FLASK_DEBUG = "1",
        },
        args = {
          "run",
          "--no-debugger",
          "--no-reload",
        },
        jinja = true,
        autoStartBrowser = false,
      },
      {
        name = "Python: Debug Python File",
        type = "debugpy",
        request = "launch",
        program = "${file}",
      },
    }
  end,
}
