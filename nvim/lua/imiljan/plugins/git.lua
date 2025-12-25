return {
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git" },
    keys = {
      -- { "<leader>gs", ":Git<CR>", desc = "Fugitive: Status" },
      -- { "<leader>gfp", ":Git pull<CR>", desc = "Fugitive: Pull" },
      -- { "<leader>gfP", ":Git push<CR>", desc = "Fugitive: Push" },
    },
    config = function()
      -- vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>", { desc = "Fugitive: Diff Take Left" })
      -- vim.keymap.set("n", "gl", "<cmd>diffget //3<CR>", { desc = "Fugitive: Diff Take Right" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {},
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          vim.keymap.set("n", "]g", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]q", bang = true })
            else
              gs.nav_hunk("next")
            end
          end, { buffer = bufnr, desc = "HUNK: Next" })

          vim.keymap.set("n", "[g", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[g", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end, { buffer = bufnr, desc = "HUNK: Prev" })

          vim.keymap.set("n", "<leader>ga", gs.stage_hunk, { buffer = bufnr, desc = "HUNK: Add (stage)" })
          vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { buffer = bufnr, desc = "HUNK: reset" })

          vim.keymap.set("v", "<leader>ga", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { buffer = bufnr, desc = "HUNK: Add (stage)" })
          vim.keymap.set("v", "<leader>gr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { buffer = bufnr, desc = "HUNK: reset" })

          vim.keymap.set("n", "<leader>gA", gs.stage_buffer, { buffer = bufnr, desc = "HUNK: Add (stage) buffer" })
          vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { buffer = bufnr, desc = "HUNK: reset buffer" })

          vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { buffer = bufnr, desc = "HUNK: preview" })
          vim.keymap.set("n", "<leader>gi", gs.preview_hunk_inline, { buffer = bufnr, desc = "HUNK: preview inline" })

          vim.keymap.set("n", "<leader>gb", function()
            gs.blame_line({ full = true })
          end, { buffer = bufnr, desc = "HUNK: blame line" })

          vim.keymap.set("n", "<leader>gd", gs.diffthis, { buffer = bufnr, desc = "HUNK: diff" })
          vim.keymap.set("n", "<leader>gD", function()
            gs.diffthis("~")
          end, { buffer = bufnr, desc = "HUNK: diff file" })

          vim.keymap.set("n", "<leader>gQ", function()
            gs.setqflist("all")
          end, { buffer = bufnr, desc = "HUNK: Quickfix" })
          vim.keymap.set("n", "<leader>gq", gs.setqflist, { buffer = bufnr, desc = "HUNK: quickfix" })

          vim.keymap.set("n", "<leader>gtb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "HUNK: toggle current line blame" })
          vim.keymap.set("n", "<leader>gtw", gs.toggle_word_diff, { buffer = bufnr, desc = "HUNK: toggle word diff" })

          -- vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { buffer = bufnr, desc = "HUNK: undo stage" })
          -- vim.keymap.set("n", "<leader>gtd", gs.toggle_deleted, { buffer = bufnr, desc = "HUNK: toggle deleted" })

          vim.keymap.set({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "HUNK: Select hunk" })
        end,
      })

      vim.keymap.set("n", "<leader>gBr", "<cmd>silent !gh repo view --web<cr>", { desc = "Git: Browser REPO" })
      vim.keymap.set("n", "<leader>gBp", "<cmd>silent !gh pr view --web<cr>", { desc = "Git: Browser PR" })
    end,
  },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
      { "<leader>go", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
      { "<leader>gY", "<cmd>GitLink! blame<cr>", mode = { "n", "v" }, desc = "Open git link - Blame" },
    },
  },
}
