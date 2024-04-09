return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      event = "VeryLazy",
      dependencies = { "nvim-neotest/nvim-nio" },
      -- stylua: ignore
      keys = {
        { "<leader>du", function() require("dapui").toggle({}) end, desc = "DAP: UI" },
        { "<leader>de", function() require("dapui").eval() end,     desc = "DAP: Eval", mode = { "n", "v" } },
      },
      opts = {},
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup(opts)

        -- stylua: ignore
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
        -- stylua: ignore
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
        -- stylua: ignore
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end
      end,
    },
    { "theHamsta/nvim-dap-virtual-text", opts = {} },
    -- Add your own debuggers here
    { "mxsdev/nvim-dap-vscode-js",       ft = { "typescript", "javascript" } },
    {
      "microsoft/vscode-js-debug",
      lazy = true,
      build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
      ft = { "typescript", "javascript" },
    },
    { "mfussenegger/nvim-dap-python", ft = "python" },
  },
  -- stylua: ignore
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "DAP: Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "DAP: Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end,                                             desc = "DAP: Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end,                        desc = "DAP: Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "DAP: Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end,                                                desc = "DAP: Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end,                                            desc = "DAP: Step Into" },
    { "<leader>dj", function() require("dap").down() end,                                                 desc = "DAP: Down" },
    { "<leader>dk", function() require("dap").up() end,                                                   desc = "DAP: Up" },
    { "<leader>dl", function() require("dap").run_last() end,                                             desc = "DAP: Run Last" },
    { "<leader>do", function() require("dap").step_out() end,                                             desc = "DAP: Step Out" },
    { "<leader>dO", function() require("dap").step_over() end,                                            desc = "DAP: Step Over" },
    { "<leader>dp", function() require("dap").pause() end,                                                desc = "DAP: Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "DAP: Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end,                                              desc = "DAP: Session" },
    { "<leader>dt", function() require("dap").terminate() end,                                            desc = "DAP: Terminate" },
    { "<leader>dT", function() require("dap").toggle() end,                                               desc = "DAP: Toggle last sesson results" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "DAP: Widgets" },
  },
  config = function()
    local dap = require("dap")

    local sign = vim.fn.sign_define
    sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

    -- vim.fn.sign_define(
    -- 	"DapBreakpoint",
    -- 	{ text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    -- )

    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F8>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F9>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Set Breakpoint" })

    -- JS/TS
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    })

    for _, language in ipairs({ "typescript", "javascript" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Mocha Tests",
          program = "${file}",
          runtimeArgs = { "${workspaceFolder}/node_modules/mocha/bin/_mocha" },
          args = {
            "-r",
            "ts-node/register",
            "--timeout",
            "999999",
            "--colors",
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
      }
    end

    -- Python
    require("dap-python").setup("~/.venvs/.nvim-venv/bin/python")
    dap.configurations.python = {
      {
        name = "Python Debugger: Flask",
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
        name = "Python Debugger: Python File",
        type = "debugpy",
        request = "launch",
        program = "${file}",
      },
    }
  end,
}
