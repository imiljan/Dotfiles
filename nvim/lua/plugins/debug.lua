return {
	{
		"microsoft/vscode-js-debug",
		lazy = true,
		build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
		fp = { "typescript", "javascript" },
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "rcarriga/nvim-dap-ui", event = "VeryLazy" },
			"theHamsta/nvim-dap-virtual-text",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",

			-- Add your own debuggers here
			-- "lewluz/nvim-dap-go",
			{ "mxsdev/nvim-dap-vscode-js", ft = { "typescript", "javascript" } },
			{ "mfussenegger/nvim-dap-python", ft = "python" },
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				automatic_setup = true,
				handlers = {},
				ensure_installed = { --[[ "delve", ]]
					"python",
				},
			})

			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			-- Basic debugging keymaps, feel free to change to your liking!
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Set Breakpoint" })

			dapui.setup()
			require("nvim-dap-virtual-text").setup()

			-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
			vim.keymap.set("n", "<F7>", dapui.toggle, {
				desc = "Debug: See last session result.",
			})

			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			-- Install golang specific config
			-- GO
			-- require("dap-go").setup()

			-- JS/TS
			require("dap-vscode-js").setup({
				debugger_path = "/Users/imiljan/.local/share/nvim/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
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
				}
			end

			-- Python
			local temp = vim.fn.system("whereis python")
			local secondElement
			local count = 0
			for word in temp:gmatch("%S+") do
				count = count + 1
				if count == 2 then
					secondElement = word
					break
				end
			end
			require("dap-python").setup(secondElement)

			dap.configurations.python = {
				{
					name = "Python Debugger: Remote Attach",
					type = "debugpy",
					request = "attach",
					connect = {
						host = "localhost",
						port = 5000,
					},
					pathMappings = {
						localRoot = "${workspaceFolder}",
						remoteRoot = ".",
					},
				},
				{
					name = "Python Debugger: Attach using Process Id",
					type = "debugpy",
					request = "attach",
					-- processId = "${command:pickProcess}",
					processId = require("dap.utils").pick_process,
				},
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
	},
}
