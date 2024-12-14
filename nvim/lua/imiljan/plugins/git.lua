return {
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git" },
    keys = {
      { "<leader>gs", ":Git<CR>", desc = "Fugitive: Status" },
      { "<leader>gfp", ":Git pull<CR>", desc = "Fugitive: Pull" },
      { "<leader>gfP", ":Git push<CR>", desc = "Fugitive: Push" },
    },
    config = function()
      vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>", { desc = "Fugitive: Diff Take Left" })
      vim.keymap.set("n", "gl", "<cmd>diffget //3<CR>", { desc = "Fugitive: Diff Take Right" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
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
              vim.cmd.normal({ "[c", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end, { buffer = bufnr, desc = "HUNK: Prev" })

          vim.keymap.set("n", "<leader>gp", gs.preview_hunk_inline, { buffer = bufnr, desc = "HUNK: preview inline" })
          vim.keymap.set("n", "<leader>gP", gs.preview_hunk, { buffer = bufnr, desc = "HUNK: preview" })

          vim.keymap.set("n", "<leader>ga", gs.stage_hunk, { buffer = bufnr, desc = "HUNK: Add (stage)" })
          vim.keymap.set("v", "<leader>ga", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { buffer = bufnr, desc = "HUNK: Add (stage)" })

          vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { buffer = bufnr, desc = "HUNK: undo stage" })

          vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { buffer = bufnr, desc = "HUNK: reset" })
          vim.keymap.set("v", "<leader>gr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { buffer = bufnr, desc = "HUNK: reset" })

          vim.keymap.set("n", "<leader>gA", gs.stage_buffer, { buffer = bufnr, desc = "HUNK: Add (stage) buffer" })
          vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { buffer = bufnr, desc = "HUNK: reset buffer" })

          vim.keymap.set("n", "<leader>gb", function()
            gs.blame_line({ full = true })
          end, { buffer = bufnr, desc = "HUNK: blame line" })

          vim.keymap.set("n", "<leader>gd", gs.diffthis, { buffer = bufnr, desc = "HUNK: diff" })
          vim.keymap.set("n", "<leader>gD", function()
            gs.diffthis("~")
          end, { buffer = bufnr, desc = "HUNK: diff file" })

          vim.keymap.set("n", "<leader>gtb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "HUNK: toggle current line blame" })
          vim.keymap.set("n", "<leader>gtd", gs.toggle_deleted, { buffer = bufnr, desc = "HUNK: toggle deleted" })

          -- Text object
          vim.keymap.set({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "HUNK: Select hunk" })
        end,
      })

      vim.keymap.set("n", "<leader>gBr", "<cmd>silent !gh repo view --web<cr>", { desc = "Git: Browser REPO" })
      vim.keymap.set("n", "<leader>gBp", "<cmd>silent !gh pr view --web<cr>", { desc = "Git: Browser PR" })

      local telescope_builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>Gc", telescope_builtin.git_commits, { desc = "SEARCH GIT: Commits" })
      vim.keymap.set("n", "<leader>GC", telescope_builtin.git_bcommits, { desc = "SEARCH GIT: Buffer Commits" })
      vim.keymap.set("n", "<leader>Gb", telescope_builtin.git_branches, { desc = "SEARCH GIT: Branches " })
      vim.keymap.set("n", "<leader>Gs", telescope_builtin.git_status, { desc = "SEARCH GIT: Status" })
      vim.keymap.set("n", "<leader>GS", telescope_builtin.git_stash, { desc = "SEARCH GIT: Stash" })

      local telescope = require("telescope")
      vim.keymap.set("n", "<leader>Gp", telescope.extensions.gh.pull_request, { desc = "SEARCH GH: Pull Requests" })
      vim.keymap.set("n", "<leader>Gf", telescope.extensions.gh.pull_request_files, { desc = "SEARCH GH: Pull Requests Files" })
      vim.keymap.set("n", "<leader>Gr", telescope.extensions.gh.run, { desc = "SEARCH GH: Run" })
    end,
  },
}
