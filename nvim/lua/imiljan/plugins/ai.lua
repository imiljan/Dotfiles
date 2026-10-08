return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    -- enabled = false,
    dependencies = {
      -- {
      --   "copilotlsp-nvim/copilot-lsp",
      --   config = function()
      --     vim.g.copilot_nes_debounce = 500
      --   end,
      -- },
    },
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          -- accept = "<M-l>",
          accept_word = false,

          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-e>",
          -- dismiss = "<C-]>",
        },
      },
      -- nes = {
      --   enabled = false,
      --   keymap = {
      --     accept_and_goto = "<leader>w",
      --     accept = false,
      --     dismiss = "<Esc>",
      --   },
      -- },
      -- copilot_model = "", -- Use default model (GPT-3.5)
      -- copilot_model = "gpt-4o-copilot", -- Use GPT-40 (premium model)
      -- server_opts_overrides = {
      --   settings = {
      --     telemetry = false,
      --   },
      -- },
    },
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        port = vim.env.OPENCODE_PORT and tonumber(vim.env.OPENCODE_PORT) or nil,
      }

      -- vim.print(vim.inspect(vim.g.opencode_opts))

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ "n", "x" }, "<leader>at", function()
        require("opencode").ask("@this: ")
      end, { desc = "AI: Opencode THIS ask" })

      vim.keymap.set({ "n", "x" }, "<leader>as", function()
        require("opencode").select()
      end, { desc = "AI: Opencode Select action" })

      -- vim.keymap.set({ "n", "t" }, "<leader>at", function()
      --   require("opencode").toggle()
      -- end, { desc = "AI: Opencode Toggle" })

      vim.keymap.set({ "n", "x" }, "go", function()
        return require("opencode").operator("@this ")
      end, { expr = true, desc = "Add range to opencode" })
      vim.keymap.set("n", "goo", function()
        return require("opencode").operator("@this ") .. "_"
      end, { expr = true, desc = "Add line to opencode" })

      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "opencode half page up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "opencode half page down" })
    end,
  },
}
